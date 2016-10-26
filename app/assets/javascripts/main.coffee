chart = null

setWallLayout = ->
  $wall = $('.wall')
  if $wall.length
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
    item.link = item.link

  #console.dir keys

  # Sort contratistas by total amount
  keys.sort (a, b) ->
    return d3.descending(a.total, b.total)

  # Truncate array to 12 first elements
  keys.splice length, keys.length

  return keys

# get treemap data from contracts table
getTreemapData = ->
  data = [{ id: 'ob' }]
  categories = []

  # Get contracts data from contracts table
  $('#contracts tbody tr').each ->

    cat = $(this).find('.td-entity').data('id')
    
    # add category to categories array
    if categories.indexOf(cat) == -1
      categories.push cat
      data.push { id: 'ob.'+cat }
    
    # add proposal objets to data array
    data.push {
      id:           'ob.'+cat+'.'+$(this).data('id')
      entity:       $(this).find('.td-entity a').html()
      amount:       +$(this).find('.td-amount').data('value')
      description:  $(this).find('.td-description').html()
    }
  
  return data


$(document).ready ->

  # Add Packery wall layout
  setWallLayout()

  if $('#home-chart').length
    d3.json '/data/grupos-constructores', (error, json) ->
      if error
        return console.warn(error)
      chart = new BarChart 'home-chart', getFormattedData(json, 'contratista', 10)
  else if $('#companies-chart').length
    d3.json '/data/grupos-constructores', (error, json) ->
      if error
        return console.warn(error)
      chart = new BarChart 'companies-chart', getFormattedData(json, 'contratista', 10)
  else if $('#administrations-chart').length
    d3.json '/data/administraciones', (error, json) ->
      if error
        return console.warn(error)
      chart = new BarChart 'administrations-chart', getFormattedData(json, 'administracion', 10)

  if $('#treemap-chart').length
    chart = new TreemapChart 'treemap-chart', getTreemapData()
  
  # Add Datepicker in Contracts home
  if $('.contracts-filters').length
    $('.contracts-filters .input-daterange').datepicker({ language: 'es' })

  # Setup table sorting
  Sortable.init()

  # Add resize handler
  $(window).resize ->
    if chart
      chart.resize()
