---
layout: default
title: PetitBonhomme | Statistics
extra_html_head: <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
---

<h1>Statistics</h1>

<h2>Wardrobe Content</h2>

<div class="graph-wrap">
<canvas id="colorPieChart"></canvas>
</div>

<script>
const colorData = {{ site.data.clothing_items_colors | jsonify }};

const colorMapping = {};
colorData.forEach(color => {
  colorMapping[color.name] = color.HTML_code;
});

const colorCounts = {{ site.data.color_counts | jsonify }};

const colorLabels = Object.keys(colorCounts);
const colorValues = Object.values(colorCounts);
const colorHexValues = colorLabels.map(color => `#${colorMapping[color] || 'CCCCCC'}`);

const ctx = document.getElementById('colorPieChart').getContext('2d');
new Chart(ctx, {
  type: 'pie',
  data: {
    labels: colorLabels,
    datasets: [{
      data: colorValues,
      backgroundColor: colorHexValues,
      hoverOffset: 4
    }]
  },
  options: {
    responsive: true,
    plugins: {
      legend: {
        display: false,
      },
      tooltip: {
        callbacks: {
          label: function(tooltipItem) {
            return `${tooltipItem.label}: ${tooltipItem.raw.toFixed(2)}%`;
          }
        }
      }
    }
  }
});
</script>