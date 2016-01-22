chart = null

setWallLayout = ->
  $wall = $('.wall')
  if $wall.length
    console.log 'setup wall'
    $wall.imagesLoaded ->
      $wall.packery {
        itemSelector: '.wall-item',
        columnWidth: $wall.width() / 12
      }

# process Companies Data to be draw as a stacked bar chart
getFormattedData = (data, key, length) ->
  # create a nested array with 'key' / 'procemiento' / 'data' structure
  keys = d3.nest()
    .key((d) -> return d[key])
    .key((d) -> return d.procedimiento)
    .entries(data)

  # Add procedimientos attribute to contratistas array
  keys.forEach (item) ->
    total = 0
    item.procedimientos = item.values.map (procedimiento) ->
      procedimiento.total = 0
      procedimiento.values.forEach (d) ->
        procedimiento.total += +d.importe
      return { 
        name: procedimiento.key
        x0:   total
        x1:   total += procedimiento.total
      }
    item.total = total

  console.dir keys

  # Sort contratistas by total amount
  keys.sort (a, b) ->
    return d3.descending(a.total, b.total)

  # Truncate array to 12 first elements
  keys.splice length, keys.length

  return keys


$(document).ready ->

  # Add Packery wall layout
  setWallLayout()

  if $('#home-chart').length
    d3.json '/data/empresas', (error, json) ->
      if error
        return console.warn(error)
      chart = new BarChart 'home-chart', getFormattedData(json, 'contratista', 12)
  else if $('#companies-chart').length
    d3.json '/data/empresas', (error, json) ->
      if error
        return console.warn(error)
      chart = new BarChart 'companies-chart', getFormattedData(json, 'contratista', 12)
  else if $('#administrations-chart').length
    d3.json '/data/administraciones', (error, json) ->
      if error
        return console.warn(error)
      chart = new BarChart 'administrations-chart', getFormattedData(json, 'administracion', 10)
  

  # Add Datepicker in Contracts home
  if $('.contracts-filters').length
    $('.contracts-filters .input-daterange').datepicker({ language: 'es' })

  # Add resize handler
  $(window).resize ->
    if chart
      chart.resize()
