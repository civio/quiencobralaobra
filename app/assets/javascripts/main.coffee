chart = null


setWallLayout = ->
  $wall = $('.wall')
  if $wall.length
    $wall.imagesLoaded ->
      $wall.packery {
        itemSelector: '.wall-item',
        columnWidth: $wall.width() / 12
      }

setPageNavigation = ->
  # Smooth page scroll to an article section
  $('.page-navigation a[href^="#"]').click ->
    $target = $($(this).attr('href'))
    if $target.length
      $('html,body').animate({
        scrollTop: $target.offset().top+1
      }, 1000)

  menuItems = $('.page-navigation li a')

  if menuItems.length

    # Anchors corresponding to menu items
    scrollItems = menuItems.map ->
      item = $($(this).attr("href"))
      if item.length
        return item

    # activate items when scroll down
    $(window).scroll (e) ->
      
      # Get container scroll position
      fromTop = $(e.target).scrollTop()
     
      # Get id of current scroll item
      cur = scrollItems.map ->
       if $(this).offset().top <= fromTop
         return this

      # Get the id of the current element
      cur = cur[cur.length-1];
      id = if cur && cur.length then cur[0].id else ""

      if lastId != id
        lastId = id
        # Set/remove active class
        menuItems
          .parent().removeClass("active")
          .end().filter("[href=\\#"+id+"]").parent().addClass("active")


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

  # Sort contratistas by total amount
  keys.sort (a, b) ->
    return d3.descending(a.total, b.total)

  # Truncate array to 12 first elements
  keys.splice length, keys.length

  return keys


# get treemap data from contracts table
getTreemapData = ->
  data = { 'ob': {id: 'ob'} }

  # Set contracts data for each item
  setTreemapItemData = ($item, isUTE) ->
    entity = $item.find('.td-entity').data('id')
    value  = +$item.find('.td-amount').data('value')
    if data['ob.'+entity]
      unless isUTE
        data['ob.'+entity].amount += value
      data['ob.'+entity].amountUTE += value
    else
      data['ob.'+entity] =
        id:       'ob.'+entity
        entity:    $item.find('.td-entity a').html()
        amount:    if isUTE == true then 0 else value
        amountUTE: value
        type:      if $item.data('body-type') then slugify($item.data('body-type')) else ''

  # Get contracts data from contracts table
  $('#contracts tbody tr').each ->
    setTreemapItemData $(this), false

  #Get contracts data from contracts ute table
  $('#contracts-utes tbody tr').each ->
    setTreemapItemData $(this), true

  return d3.values data


# get treemap data from contracts table
getBarsData = ->
  data = {}

  # Set contracts data for each item
  setBarItemData = ($item, isUTE) ->
    date   = $item.find('.td-date').html()
    amount = +$item.find('.td-amount').data('value')
    # avoid empty dates
    if date
      date = date.split('-').slice(0,-1).join('-')
      if data[date]
        data[date].amount    += if isUTE == true then 0 else amount
        data[date].amountUTE += amount
      else
        data[date] = 
          amount:    if isUTE == true then 0 else amount
          amountUTE: amount
 
  # Get contracts data from contracts table
  $('#contracts tbody tr').each ->
    setBarItemData $(this), false

  #Get contracts data from contracts ute table
  $('#contracts-utes tbody tr').each ->
    setBarItemData $(this), true

  return d3.entries data


slugify = (s) ->
  return s
    .trim()
    .toLowerCase()
    .replace(/\s+/g, '-')
    .replace(/[^\w\-]+/g, '')
    .replace(/\-\-+/g, '-')
    .replace(/^-+/, '')
    .replace(/-+$/, '')


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
    # Setup utes switch
    $('#utes-switch')
      .bootstrapSwitch()
      .on 'switchChange.bootstrapSwitch', (e, state) ->
        chart.update state
      
  if $('#timeline-bar-chart').length
    timelineBarsChart = new TimelineBarsChart 'timeline-bar-chart', getBarsData(), $('#contracts-utes').length > 0
  
  # Add Datepicker & Range Slider in Contracts home
  if $('.contracts-filters').length
    $('.contracts-filters .input-daterange').datepicker({ language: 'es' })
    $('.contracts-filters input#amount').ionRangeSlider()

  # Setup table sorting
  Sortable.init()

  # Setup contracts search selects
  $('.contracts-filters #bidder, .contracts-filters #public_bodies').select2()

  # Setup affix for contracts tables
  # $('#contracts').affix
  #   offset:
  #     top: () -> console.log($(this)); return 100 #$(this).offset().top

  # Setup the law page navigation
  if $('body').hasClass('the_law')

    $('.law-navigation .panel').affix
      offset:
        top: -> return $('.law-navigation').offset().top-20
        bottom: -> return $('.footer').height()+75
        #bottom: -> return $('.law .col-sm-9 .panel').offset().top + $('.law .col-sm-9 .panel').height()

    setPageNavigation()


  # Add resize handler
  $(window).resize ->
    if chart
      chart.resize()
    if timelineBarsChart
      timelineBarsChart.resize()
