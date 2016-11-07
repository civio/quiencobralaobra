class window.TimelineBarsChart

  constructor: (id, data, utes, options) ->   
    TimelineBarsChart.setup id, data, utes, options
    TimelineBarsChart.draw()


  # Setup funcion
  @setup: (id, data, utes, options) ->

    # Setup default vars
    @options        = options || {}
    @options.id     = id
    @options.utes   = utes
    @options.margin = @options.margin || {top: 0, right: 0, bottom: 20, left: 0}
    @data           = data || []

    # get main element
    @$el = $('#'+@options.id)

    # get tooltip 
    @$tooltip = @$el.find('.popover')

    # get sizes
    @getSizes()

    d3.timeFormatDefaultLocale {
      dateTime: "%a %b %e %X %Y"
      date: "%d/%m/%Y"
      time: "%H:%M:%S"
      periods: ["AM", "PM"]
      days: ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"]
      shortDays: ["Dom", "Lun", "Mar", "Mi", "Jue", "Vie", "Sab"]
      months: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
      shortMonths: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
    }
    d3.formatDefaultLocale {thousands: '.', grouping: [3]}
    @budgetFormat = d3.format(',d')
    @formatDateTooltip = d3.timeFormat('%B %Y')
    @formatDate = d3.timeFormat('%Y-%m')

    # format data
    parseTime = d3.timeParse('%Y-%m')
    @data.forEach (d) =>
      d.date = parseTime d.key
      d.amount = d.value.amount
      d.amountUTE = d.value.amountUTE

    # get minimum date between 2008-01 & 2009-01
    # as explained in https://github.com/civio/quiencobralaobra/issues/65
    filteredData = @data.filter (d) -> return d.date.getFullYear() >= 2008
    min = d3.min filteredData, (d) -> return d.date
    min = d3.min [min, parseTime('2009-01')]
   
    @x = d3.scaleTime()
      .domain [min, parseTime('2016-01')]
      .range [0, @width]

    @y = d3.scaleLinear()
      .domain [0, d3.max(@data, (d) => return if @options.utes == true then d.value.amountUTE else d.value.amount)]
      .range [@height, 0]

    @axisBottom = d3.axisBottom(@x)
      .ticks d3.timeYear.every(1)
      .tickFormat d3.timeFormat('%Y')
      .tickSize 0
      .tickPadding 6

    @monthLength = @getMonthLength()

    @bisectDate = d3.bisector( (d) -> return d.date ).left

    # Setup svg
    @svg = d3.select('#'+@options.id).append('svg')
      .attr 'class', 'chart'
      .attr 'width', @width + @options.margin.right + @options.margin.left
      .attr 'height', @height + @options.margin.top + @options.margin.bottom
      .append('g')
        .attr 'transform', 'translate(' + @options.margin.left + ',' + @options.margin.top + ')'


  # Draw function
  @draw: ->

    @axisX = @svg.append('g')
      .attr 'class', 'axis axis-x'
      .attr 'transform', 'translate(0,' + @height + ')'
      .call @axisBottom

    @bar = @svg.selectAll('.bar')
      .data @data

    if @options.utes
      @bar.enter()
        .append('rect')
          .attr 'class', 'bar bar-ute'
          .call @setBarsUTEAttributes

    @bar.enter()
      .append('rect')
        .attr 'class', 'bar bar-group'
        .call @setBarsAttributes

    @overlay = @svg.append('rect')
      .attr 'class', 'overlay'
      .attr 'width', @width
      .attr 'height', @height
      .call @setBarsEvents

  @addEntityBars: (entity) ->
    console.log entity


  # Get width & height
  @getSizes: ->

    @width = @$el.width()

    # height based on width
    if @width > 1000
      @height = @width * 0.5
    else if @width > 700
      @height = @width * 0.5625
    else if @width > 500
      @height = @width * 0.75
    else
      @height = @width

    # update element height
    @$el.height @height
  

  # Resize function
  @resize: ->
    # Skip if width value doesn't change
    if @width == @$el.width()
      return

    # Update values
    @getSizes()

    d3.select('#'+@options.id).select('svg')
      .attr 'width', @width + @options.margin.right + @options.margin.left
      .attr 'height', @height + @options.margin.top + @options.margin.bottom
 
    @x.range [0, @width]
    @y.range [@height, 0]

    @axisBottom.scale @x

    @axisX
      .attr 'transform', 'translate(0,' + @height + ')'
      .call @axisBottom

    @svg.selectAll('.bar-group')
      .call @setBarsAttributes

    @svg.selectAll('.bar-ute')
      .call @setBarsUTEAttributes

    @overlay
      .attr 'width', @width
      .attr 'height', @height

    
  @setBarsEvents: (selection) =>
    selection
      .on 'mouseover', @onMouseOver
      .on 'mousemove', @onMouseMove
      .on 'mouseout',  @onMouseOut

  @setBarsAttributes: (selection) =>
    selection
      .attr 'x', (d) => return @x(d.date)
      .attr 'y', (d) => return @y(d.value.amount)
      .attr 'width', (@width/@monthLength)-1
      .attr 'height', (d) => return @height - @y(d.value.amount)

  @setBarsUTEAttributes: (selection) =>
    selection
      .attr 'x', (d) => return @x(d.date)
      .attr 'y', (d) => return @y(d.value.amountUTE)
      .attr 'width', (@width/@monthLength)-1
      .attr 'height', (d) => return @height - @y(d.value.amountUTE)


  @onMouseOver: (e) =>
    # Show popover
    @$tooltip.show()


  @onMouseMove: (e) =>
    # get element offset
    offset = @$el.offset()
    # Setup popover position
    @$tooltip.css
      left: d3.event.pageX - offset.left - @$tooltip.width()*0.5
      top:  d3.event.pageY - offset.top - @$tooltip.height() - 12

    mouseDate = @x.invert(d3.mouse(d3.event.currentTarget)[0])
    mouseDateFormatted = @formatDate(mouseDate)

    # skip if date has nost changed
    if @currentDate == mouseDateFormatted
      return

    @currentDate = mouseDateFormatted
    mouseData = @data.filter (d) -> d.key == mouseDateFormatted
    amount    = if mouseData.length > 0 then mouseData[0].amount else 0
    amountUTE = if mouseData.length > 0 then mouseData[0].amountUTE else 0

    # Hover current bar
    @svg.selectAll('.bar')
      .style 'opacity', (d) => return if @formatDate(d.date) == mouseDateFormatted then 1 else 0.3

    # Setup content
    @$tooltip.find('.popover-title span').html    @formatDateTooltip(mouseDate)
    @$tooltip.find('.popover-budget strong').html @budgetFormat(amountUTE)
    if @options.utes
      @$tooltip.find('.popover-budget-alone strong').html @budgetFormat(amount)
      if amountUTE == amount
        @$tooltip.find('.popover-budget-ute, .popover-budget-alone').hide()
      else
        @$tooltip.find('.popover-budget-ute strong').html @budgetFormat(amountUTE-amount)
        @$tooltip.find('.popover-budget-ute, .popover-budget-alone').show()


  @onMouseOut: (e) =>
    # Remove hover bar
    @svg.selectAll('.bar')
      .style 'opacity', 1
    # Hide popover
    @$tooltip.hide()


  # get number of months between min & max dates
  @getMonthLength: ->

    formatYear = d3.timeFormat('%Y')
    formatMonth = d3.timeFormat('%m')

    minYear  = +formatYear  @x.domain()[0]
    minMonth = +formatMonth @x.domain()[0]
    maxYear  = +formatYear  @x.domain()[1]
    maxMonth = +formatMonth @x.domain()[1]

    return ((maxYear-minYear)*12) + maxMonth - minMonth
   

  # Public Resize method 
  resize: ->
    TimelineBarsChart.resize()

  addEntityBars: (entity) ->
    TimelineBarsChart.addEntityBars(entity)
