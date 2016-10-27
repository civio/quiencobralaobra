class window.TimelineBarsChart

  constructor: (id, data, options) ->   
    TimelineBarsChart.setup id, data, options
    TimelineBarsChart.draw()


  # Setup funcion
  @setup: (id, data, options) ->

    # Setup default vars
    @options        = options || {}
    @options.id     = id
    @options.margin = @options.margin || {top: 0, right: 0, bottom: 50, left: 0}
    @data           = data || []
    
    # get main element
    @$el = $('#'+@options.id)

    # get tooltip 
    @$tooltip = @$el.find('.popover')

    # get sizes
    @getSizes()

    d3.formatDefaultLocale {thousands: '.', grouping: [3]}
    @budgetFormat = d3.format(',d')
    @formatTime = d3.timeFormat('%B %Y')

    # format data
    parseTime = d3.timeParse('%Y-%m')
    @data.forEach (d) =>
      d.date = parseTime d.key
      d.value = +d.value

    # get minimum date between 2008-01 & 2009-01
    # as explained in https://github.com/civio/quiencobralaobra/issues/65
    filteredData = @data.filter (d) -> return d.date.getFullYear() >= 2008
    min = d3.min filteredData, (d) -> return d.date
    min = d3.min [min, parseTime('2009-01')]
   
    @x = d3.scaleTime()
      .domain [min, parseTime('2016-01')]
      .range [0, @width]

    @y = d3.scaleLinear()
      .domain [0, d3.max(@data, (d) -> return d.value)]
      .range [@height, 0]

    @axisBottom = d3.axisBottom(@x)
      .ticks d3.timeYear.every(1)
      .tickFormat d3.timeFormat('%Y')
      .tickSize 0
      .tickPadding 6
    
    @monthLength = @getMonthLength()

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
      .enter()
        .append('rect')
          .attr 'class', 'bar'
          .call @setBarsAttributes
          .on 'mouseover', @onMouseOver
          .on 'mousemove', @onMouseMove
          .on 'mouseout',  @onMouseOut


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

    @svg.selectAll('.bar')
      .call @setBarsAttributes
    
 
  @setBarsAttributes: (selection) =>
    selection
      .attr 'x', (d) => return @x(d.date)
      .attr 'y', (d) => return @y(d.value)
      .attr 'width', (@width/@monthLength)-1
      .attr 'height', (d) => return @height - @y(d.value)


  @onMouseOver: (e) =>
    # Setup content
    @$tooltip.find('.popover-title span').html      @formatTime(e.date)
    @$tooltip.find('.popover-budget strong').html   @budgetFormat(e.value)
    # Show popover
    @$tooltip.show()


  @onMouseMove: (e) =>
    # get element offset
    offset = @$el.offset()
    # Setup popover position
    @$tooltip.css
      left: d3.event.pageX - offset.left - @$tooltip.width()*0.5
      top:  d3.event.pageY - offset.top - @$tooltip.height() - 12


  @onMouseOut: (e) =>
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
