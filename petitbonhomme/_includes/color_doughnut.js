{% assign prefix = include.prefix | default: '' %}
{% assign entity_name = include.entity_name | default: '' %}

Chart.register(ChartDataLabels);

const {{prefix}}ColorData = {{ site.data[include.data_name] | raw }};

// Prepare data for the inner ring (families)
const {{prefix}}FamColorLabels = {{prefix}}ColorData.map(family => family.family);
const {{prefix}}FamColorCounts = {{prefix}}ColorData.map(family => family.total);
const {{prefix}}FamColors = {{prefix}}ColorData.map(family => family.hex);

// Prepare data for the outer ring (individual colors within families)
const {{prefix}}ColorLabels = [];
const {{prefix}}ColorCounts = [];
const {{prefix}}ColorHexValues = [];

{{prefix}}ColorData.forEach(family => {
  family.colors.forEach(color => {
    {{prefix}}ColorLabels.push(color.name);
    {{prefix}}ColorCounts.push(color.count);
    {{prefix}}ColorHexValues.push(color.hex);
  });
});

function isLightColor(color) {
  // Convert HEX or RGB to RGB values if needed
  let r, g, b;

  if (color.startsWith('rgb')) {
    // Extract RGB values from rgb(255, 255, 255)
    const rgbValues = color.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
    r = parseInt(rgbValues[1], 10);
    g = parseInt(rgbValues[2], 10);
    b = parseInt(rgbValues[3], 10);
  } else if (color.startsWith('#')) {
    // Convert HEX to RGB
    r = parseInt(color.substring(1, 3), 16);
    g = parseInt(color.substring(3, 5), 16);
    b = parseInt(color.substring(5, 7), 16);
  }

  // Calculate luminance (perceived brightness)
  const luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b;

  // Return true if the color is light, false if dark
  return luminance > 150;
}

const {{prefix}}ColorDoughnutChart = document.getElementById('{{ include.element_id }}').getContext('2d');
new Chart({{prefix}}ColorDoughnutChart, {
  type: 'doughnut',
  data: {
    labels: [...{{prefix}}FamColorLabels, ...{{prefix}}ColorLabels],
    datasets: [
      {
        label: 'Families',
        data: {{prefix}}FamColorCounts,
        backgroundColor: {{prefix}}FamColors,
        hoverOffset: 4,
        borderWidth: 0.5,
      },
      {
        label: 'Colors',
        data: {{prefix}}ColorCounts,
        backgroundColor: {{prefix}}ColorHexValues,
        hoverOffset: 4,
        borderWidth: 0.5,
      }
    ]
  },
  options: {
    responsive: true,
    cutout: '30%',
    plugins: {
      datalabels: {
        backgroundColor: function(context) {
          return context.dataset.backgroundColor[context.dataIndex];
        },
        hoverOffset: 4,
        anchor: 'center',
          color: function(context) {
          // Get the background color for the current section
          const backgroundColor = context.dataset.backgroundColor[context.dataIndex];

          // Check if the background color is light or dark
          return isLightColor(backgroundColor) ? 'black' : 'white';
        },
        font: function(context) {
          const width = context.chart.width;
          const height = context.chart.height;
          // Use a dynamic font size based on the chart's size
          const size = Math.min(width, height) / 30 ;

          return {
            weight: 'bold',
            size: size
          };
        },
        borderRadius: 20,
        padding: 1,
        display: function(context) {
          // Show label only if value is above a certain threshold
          const value = context.dataset.data[context.dataIndex];
          return value > 5; // Adjust threshold as needed
        },
        formatter: function (value, context) {
          const datasetIndex = context.datasetIndex;
          const dataIndex = context.dataIndex;

          // Determine the correct count based on whether it's the family or color dataset
          const count = datasetIndex === 0
            ? {{prefix}}FamColorCounts[dataIndex]  // Family count
            : {{prefix}}ColorCounts[dataIndex];    // Color count

          return `${count}%`;
        },
      },
      legend: {
        display: false,
      },
      tooltip: {
        callbacks: {
          title: function(tooltipItems) {
            const tooltipItem = tooltipItems[0];
            const datasetIndex = tooltipItem.datasetIndex;
            const dataIndex = tooltipItem.dataIndex;

            // Retrieve correct label
            const label = datasetIndex === 0
                ? {{prefix}}FamColorLabels[dataIndex] // Family label
                : {{prefix}}ColorLabels[dataIndex]; // Color label

            return `${label}`;
          },
          label: function(tooltipItem) {
            const datasetIndex = tooltipItem.datasetIndex;
            const dataIndex = tooltipItem.dataIndex;

            // Retrieve correct label
            const label = datasetIndex === 0
                ? {{prefix}}FamColorLabels[dataIndex] // Family label
                : {{prefix}}ColorLabels[dataIndex]; // Color label

            const count = tooltipItem.raw;
            return datasetIndex === 0
                ? ` ${label} Family: ${count}%`
                : ` ${label}: ${count}%`;
          }
        }
      }
    }
  }
});
