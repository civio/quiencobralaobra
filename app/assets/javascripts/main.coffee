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
getCompaniesData = (data) ->
  # create a nested array with 'contratista' / 'procemiento' / 'data' structure
  contratistas = d3.nest()
    .key((d) -> return d.contratista)
    .key((d) -> return d.procedimiento)
    .entries(data)

  # Add procedimientos attribute to contratistas array
  contratistas.forEach (contratista) ->
    total = 0
    contratista.procedimientos = contratista.values.map (procedimiento) ->
      procedimiento.total = 0
      procedimiento.values.forEach (d) ->
        procedimiento.total += +d.importe
      return { 
        name: procedimiento.key
        x0:   total
        x1:   total += procedimiento.total
      }
    contratista.total = total

  console.dir contratistas

  # Sort contratistas by total amount
  contratistas.sort (a, b) ->
    return d3.descending(a.total, b.total)

  # Truncate array to 12 first elements
  contratistas.splice 12, contratistas.length

  return contratistas


$(document).ready ->

  # Add Packery wall layout
  setWallLayout()

  if $('#home-chart').length
    d3.json '/data/empresas', (error, json) ->
      if error
        return console.warn(error)
      chart = new BarChart 'home-chart', getCompaniesData(json)
  else if $('#companies-chart').length
    d3.json '/data/empresas', (error, json) ->
      if error
        return console.warn(error)
      chart = new BarChart 'companies-chart', getCompaniesData(json)
  

  # Add Datepicker in Contracts home
  if $('.contracts-filters').length
    $('.contracts-filters .input-daterange').datepicker({ language: 'es' })

  # Add resize handler
  $(window).resize ->
    if chart
      chart.resize()
