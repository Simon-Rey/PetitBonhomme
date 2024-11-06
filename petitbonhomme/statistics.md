---
layout: default
title: PetitBonhomme | Statistics
extra_html_head: <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
---

<h1>Statistics</h1>

<h2>Wardrobe Content</h2>

<div class="graph-wrap">
  <canvas id="colorDoughnutChart" width="400" height="400"></canvas>
</div>

<script>
const familyData = {{ site.data.color_family_counts | jsonify }};

// Prepare data for the inner ring (families)
const familyLabels = Object.keys(familyData);
const familyCounts = familyLabels.map(family => familyData[family].total);
const familyColors = familyLabels.map(family => `#${familyData[family].hex}`);

// Prepare data for the outer ring (individual colors within families)
const colorLabels = [];
const colorCounts = [];
const colorHexValues = [];

familyLabels.forEach(family => {
  const familyInfo = familyData[family];
  Object.keys(familyInfo.colors).forEach(color => {
    colorLabels.push(color);
    colorCounts.push(familyInfo.colors[color].count);
    colorHexValues.push(`#${familyInfo.colors[color].hex}`);
  });
});

const familyLabelCount = familyLabels.length;
console.log(familyLabelCount);
const ctx = document.getElementById('colorDoughnutChart').getContext('2d');
new Chart(ctx, {
  type: 'doughnut',
  data: {
    labels: [...familyLabels, ...colorLabels],
    datasets: [
      {
        label: 'Families',
        data: familyCounts,
        backgroundColor: familyColors,
        hoverOffset: 4
      },
      {
        label: 'Colors',
        data: colorCounts,
        backgroundColor: colorHexValues,
        hoverOffset: 4
      }
    ]
  },
  options: {
    responsive: true,
    cutout: '50%',
    plugins: {
      legend: { display: false },
      tooltip: {
        callbacks: {
          title: function(tooltipItems) {
            const tooltipItem = tooltipItems[0];
            const datasetIndex = tooltipItem.datasetIndex;
            const dataIndex = tooltipItem.dataIndex;
            
            // Retrieve correct label
            const label = datasetIndex === 0 
                ? tooltipItem.chart.data.labels[dataIndex] // Family label
                : tooltipItem.chart.data.labels[dataIndex + familyLabelCount]; // Color label

            return `${label}`;
          },
          label: function(tooltipItem) {
            const datasetIndex = tooltipItem.datasetIndex;
            const dataIndex = tooltipItem.dataIndex;
            
            // Retrieve correct label
            const label = datasetIndex === 0 
                ? tooltipItem.chart.data.labels[dataIndex] // Family label
                : tooltipItem.chart.data.labels[dataIndex + familyLabelCount]; // Color label

            const count = tooltipItem.raw;
            return datasetIndex === 0 
                ? `${label} Family: ${count} items`
                : `${label}: ${count} items`;
          }
        }
      }
    }
  }
});
</script>

