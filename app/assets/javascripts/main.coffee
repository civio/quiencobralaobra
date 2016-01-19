$(document).ready ->
  console.log 'Hello!'
  if $('#home-chart').length
    homeChart = new BarChart {data: [4, 8, 15, 16, 23, 42], width: $('#home-chart').width()}
    console.log 'homeChart', homeChart

  $(window).resize ->
    if homeChart
      console.log 'resize'
      homeChart.resize $('#home-chart').width()
