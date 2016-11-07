class window.BarChart

  constructor: (id, data, options) ->
    options = options || {}
    BarChart.setup id, data, options
    BarChart.draw()


  # Setup funcion
  @setup: (id, data, options) ->

    # Setup default vars
    @$el       = $('#'+id)
    @data      = data || []
    @barHeight = options.barHeight || 25
    @width     = @$el.width()

    # Setup x function
    @x = d3.scaleLinear()
      .domain([0, d3.max(@data, (d) -> return d.total)])
      .rangeRound([0, @width])

    # Setup svg
    @svg = d3.select('#'+id).append('svg')
      .attr('class', 'chart')
      .attr('width', @width)
      .attr('height', 2 * @barHeight * @data.length)

    # Get tooltip 
    @$tooltip = $('#'+id+' .popover')


  # Draw function
  @draw: ->
    
    # Create bars
    @bars = @svg.selectAll('g')
      .data(@data)
    .enter().append('g')
      .attr('transform', (d, i) => return 'translate(0,' + 2 * i * @barHeight + ')')

    # Append Rect to Bars
    @bars.selectAll('rect')
      .data((d) -> return d.items)
    .enter().append('rect')
      .attr('class', (d) -> return d.name.toLowerCase().split(' ').join('-') )
      .attr('x', (d) => return @x(d.x0) )
      .attr('y', @barHeight)
      .attr('width', (d) => return @x(d.x1) - @x(d.x0) )
      .attr('height', @barHeight-1)
      .on('mouseover', @onMouseOver)
      .on('mousemove', @onMouseMove)
      .on('mouseout', @onMouseOut)

    # Append text with amount to Bars
    # @bars.append('text')
    #   .attr('class', 'amount')
    #   .attr('x', 6) #(d) => return @x(d.amount)-6 )
    #   .attr('y', @barHeight )
    #   .attr('dy', '1.125em')
    #   .text((d) -> return d.total.toLocaleString('es-ES') + ' €' )

    # Append Label with 'contratista' to Bars
    @bars.append('svg:a')
      .attr('class', 'label')
      .attr('xlink:href', (d) -> return d.link )
      .append('svg:text')
        .text((d) -> return d.key )
        .attr('x', 0 )
        .attr('y', @barHeight )
        .attr('dy', '-0.375em')

  @onMouseOver: (d) =>
    if @$el.attr('id') == 'companies-chart'
      data = d3.select(d3.event.target.parentNode).datum()
      amountAlone = data.items[1].x0
      amountTotal = data.items[1].x1
      @$tooltip.find('.popover-title').html(data.key)
      @$tooltip.find('.popover-budget strong').html(amountTotal.toLocaleString('es-ES'))
      @$tooltip.find('.popover-budget-alone strong').html(amountAlone.toLocaleString('es-ES'))
      @$tooltip.find('.popover-budget-ute strong').html((amountTotal-amountAlone).toLocaleString('es-ES'))
    else
      @$tooltip.find('.popover-title').html(d.name)
      @$tooltip.find('.popover-budget strong').html((d.x1 - d.x0).toLocaleString('es-ES'))
    @$tooltip.show()

  @onMouseMove: =>
    offset = @$el.offset()
    @$tooltip.css
      left: d3.event.pageX - offset.left - @$tooltip.width()*0.5
      top:  d3.event.pageY - offset.top - @$tooltip.height() - 12

  @onMouseOut: =>
    @$tooltip.hide()

  # Resize function
  @resize: ->

    # Skip if width value doesn't change
    if @width == @$el.width()
      return

    # Update values
    @width = @$el.width()
    @x.range([0, @width])
    @svg.attr('width', @width)
   
    # Update Bars widths
    @bars.selectAll('rect')
      .attr('x', (d) => return @x(d.x0) )
      .attr('width', (d) => return @x(d.x1) - @x(d.x0) )


  # Public Resize method 
  resize: ->
    BarChart.resize()
