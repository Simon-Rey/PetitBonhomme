import os
from collections import defaultdict

import yaml
from tkinter import Tk, Label, Button, Canvas, Frame
from PIL import Image, ImageTk


# Load YAML data from a file
def load_yaml_data(file_path):
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)
    return data


# Save the updated YAML file
def save_yaml_data(file_path, data):
    with open(file_path, 'w') as file:
        yaml.dump(data, file, sort_keys=False, encoding='utf-8', allow_unicode=True)


# Display image and update color options
def display_image_and_update_colors(folder_path, yaml_data, yaml_file, color_data):
    root = Tk()
    root.title("Clothing Item Color Selector")
    color_family_map = defaultdict(list)
    for color in color_data:
        color_family_map[color["family"]].append((color["name"], "#" + color["HTML_code"]))

    img_label = Label(root)
    img_label.grid(row=0, column=0, columnspan=5, padx=20, pady=20)

    current_item_index = [0]

    # Skip items without a valid image path
    while yaml_data[current_item_index[0]]['image'] == 'Close-Up/':
        current_item_index[0] += 1

    def show_item_image():
        item = yaml_data[current_item_index[0]]
        if "image" in item:
            img_path = os.path.join(folder_path, item["image"].replace('/', os.path.sep))
            img = Image.open(img_path)
            img.thumbnail((300, 300))
            img = ImageTk.PhotoImage(img)
            img_label.config(image=img)
            img_label.image = img
            display_colors(item.get("colors", []))
            item_name_label.config(text=item["name"])
        else:
            img_label.config(image="")
            img_label.image = None

    def display_colors(selected_colors):
        # Clear existing color squares and family labels
        for widget in colors_frame.winfo_children():
            widget.destroy()

        # Display color options grouped by family in rows
        row = 0
        for family, family_colors in color_family_map.items():
            # Create a label for the family
            family_label = Label(colors_frame, text=family, font=("Helvetica", 10, "bold"))
            family_label.grid(row=row, column=0, padx=5, pady=5, sticky="w")

            # Create color squares for each color in the family
            col = 1  # Start placing color squares in the second column
            for color_name, color_code in family_colors:
                color_button = Canvas(colors_frame, width=20, height=20, bg=color_code,
                                      highlightthickness=1)

                # Highlight selected colors in blue
                if color_name in selected_colors:
                    color_button.config(highlightbackground="blue", highlightthickness=2)

                color_button.grid(row=row, column=col, padx=2, pady=2)

                # Toggle color selection on click, binding each color button instance
                color_button.bind(
                    "<Button-1>",
                    lambda event, color=color_name, button=color_button: toggle_color(event, color,
                                                                                      button)
                )

                col += 1  # Move to the next column for the next color in the family

            row += 1  # Move to the next row for the next color family

    def toggle_color(event, color, color_button):
        # Toggle the color selection for the current item
        selected_colors = yaml_data[current_item_index[0]].get("colors", [])

        if color in selected_colors:
            selected_colors.remove(color)
            color_button.config(highlightbackground="black", highlightthickness=0)
        else:
            selected_colors.append(color)
            color_button.config(highlightbackground="blue", highlightthickness=2)

        # Save the updated list of selected colors
        yaml_data[current_item_index[0]]["colors"] = selected_colors
        save_yaml_data(yaml_file, yaml_data)

    # Move to the next clothing item
    def next_item():
        current_item_index[0] = (current_item_index[0] + 1) % len(yaml_data)
        while yaml_data[current_item_index[0]]['image'] == 'Close-Up/':
            current_item_index[0] += 1
        show_item_image()

    # Display item name label
    item_name_label = Label(root, text="", font=("Helvetica", 14))
    item_name_label.grid(row=1, column=0, columnspan=5, padx=10, pady=10)

    # Frame to contain color buttons
    colors_frame = Frame(root)
    colors_frame.grid(row=2, column=0, columnspan=5, padx=10, pady=10)

    # Button to go to the next item
    next_button = Button(root, text="Next Item", command=next_item)
    next_button.grid(row=3, column=2, pady=10)

    show_item_image()
    root.mainloop()


# Main execution
if __name__ == "__main__":
    # Set paths for image folder, YAML file, and color codes file
    folder_path = os.path.join("..", "petitbonhomme", "assets", "img", "clothes")
    yaml_file = os.path.join("..", "petitbonhomme", "_data", "clothing_items.yml")
    color_file = os.path.join("..", "petitbonhomme", "_data", "clothing_items_colors.yml")

    # Load data and color mappings
    clothing_items_data = load_yaml_data(yaml_file)
    color_map = load_yaml_data(color_file)

    # Start the color selection process
    display_image_and_update_colors(folder_path, clothing_items_data, yaml_file, color_map)
