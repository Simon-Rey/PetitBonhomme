import os
import yaml
from tkinter import Tk, Label, Button, Entry, Listbox, Scrollbar
from tkinter import StringVar, END, SINGLE
from PIL import Image, ImageTk


# Load the YAML file with clothing items
def load_yaml_data(file_path):
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)
    return data


# Save the updated YAML file
def save_yaml_data(file_path, data):
    with open(file_path, 'w') as file:
        yaml.dump(data, file, sort_keys=False, encoding='utf-8', allow_unicode=True)


# Function to update the image field in the YAML data
def update_clothing_item_image(item_name, image_path, yaml_data):
    # Extract the file name from the full image path
    file_name = os.path.basename(image_path)

    # Prepend "Close-U/" to the file name
    close_up_path = f"Close-Up/{file_name}"

    # Update the item in the YAML data
    for item in yaml_data:
        if item['name'] == item_name:
            item['image'] = close_up_path  # Set to "Close-U/filename"
            return True
    return False


# Function to check if an image is already assigned to any item
def is_image_used(image_path, yaml_data):
    # Extract the file name from the full image path
    file_name = os.path.basename(image_path)

    # Construct the "Close-U/<filename>" path
    close_up_path = f"Close-Up/{file_name}"

    # Check if the image is used in any clothing item
    for item in yaml_data:
        if item.get('image') == close_up_path:
            return True
    return False


# Function to handle image display and update workflow
def display_image_and_update(folder_path, yaml_data, yaml_file):
    # Get all image files from the folder
    image_files = [f for f in os.listdir(folder_path) if f.endswith(('.png', '.jpg', '.jpeg', '.gif', '.webp'))]

    # Filter out images that are already used in any clothing item
    unused_image_files = [f for f in image_files if not is_image_used(f, yaml_data)]

    if not unused_image_files:
        print("All images are already assigned to items.")
        return

    root = Tk()
    root.title("Clothing Item Image Selector")

    img_label = Label(root)
    img_label.grid(row=0, column=0, columnspan=2, padx=20, pady=20)

    current_image_index = [0]  # List to make it mutable

    # Display the current image
    def show_image():
        img_path = os.path.join(folder_path, unused_image_files[current_image_index[0]])
        img = Image.open(img_path)
        img.thumbnail((300, 300))
        img = ImageTk.PhotoImage(img)
        img_label.config(image=img)
        img_label.image = img  # Keep a reference to avoid garbage collection

    # Automatically move to the next image
    def next_image():
        current_image_index[0] = (current_image_index[0] + 1) % len(unused_image_files)
        show_image()

    # Live update the listbox based on search input
    def search_items(event=None):
        search_term = search_var.get().lower()
        listbox.delete(0, END)
        for item in yaml_data:
            if not item["image"].endswith(".png"):
                query_words = set(search_term.split())
                if len(query_words) > 1:
                    item_name_words = set(item['name'].lower().split())
                    if query_words.issubset(item_name_words):
                        listbox.insert(END, item['name'])
                else:
                    if search_term.lower() in item["name"].lower():
                        listbox.insert(END, item['name'])

    # Function to handle listbox item click
    def on_item_click(event):
        selected_item = listbox.get(listbox.curselection())
        img_path = os.path.join(folder_path, unused_image_files[current_image_index[0]])

        # Update the selected item's image
        if update_clothing_item_image(selected_item, img_path, yaml_data):
            save_yaml_data(yaml_file, yaml_data)
            print(f"Updated {selected_item} with image {img_path}")

        # Clear the search field, move to the next image, and set focus to search
        search_var.set('')
        search_items()  # Refresh the list
        next_image()
        search_entry.focus_set()  # Set focus back to search field

    # Search field for clothing items
    search_var = StringVar()
    search_entry = Entry(root, textvariable=search_var)
    search_entry.grid(row=2, column=0, padx=10, pady=10)
    search_entry.bind('<KeyRelease>', search_items)  # Bind key release to live update the listbox
    search_entry.focus_set()  # Set focus on start

    # Listbox to show search results
    listbox = Listbox(root, selectmode=SINGLE, width=50)
    listbox.grid(row=3, column=0, columnspan=2, padx=10, pady=10)

    # Bind a click event on the listbox items to handle selection
    listbox.bind('<<ListboxSelect>>', on_item_click)

    # Scrollbar for the listbox
    scrollbar = Scrollbar(root)
    scrollbar.grid(row=3, column=2, sticky='ns')

    listbox.config(yscrollcommand=scrollbar.set)
    scrollbar.config(command=listbox.yview)

    # Populate the listbox initially
    search_items()

    show_image()  # Display the first image
    root.mainloop()


# Main execution
if __name__ == "__main__":
    # Ask the user for the folder containing images
    folder_path = os.path.join("..", "petitbonhomme", "assets", "img", "clothes", "Close-Up")

    # Load the clothing items YAML file
    yaml_file = os.path.join("..", "petitbonhomme", "_data", "clothing_items.yml")
    clothing_items_data = load_yaml_data(yaml_file)

    # Start the image display and update process
    display_image_and_update(folder_path, clothing_items_data, yaml_file)
