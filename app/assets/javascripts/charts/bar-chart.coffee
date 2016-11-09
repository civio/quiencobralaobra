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
    if id == 'companies-chart'
      @$tooltip.append("<div class='arrow'></div>\
        <div class='popover-title'></div>\
        <div class='popover-budget'><strong></strong> millones de €</div>\
        <div class='popover-budget-data popover-budget-alone'><strong></strong>% <small>en&nbsp;solitario</small></div>\
        <div class='popover-budget-data popover-budget-ute'><strong></strong>% <small>en&nbsp;UTE</small></div>")
    else
      @$tooltip.append("<div class='arrow'></div>\
        <div class='popover-title'></div>\
        <div class='popover-budget'><strong></strong> millones de €</div>
        <div class='popover-budget-data popover-budget-abierto'><strong></strong>% <small>Abierto</small></div>\
        <div class='popover-budget-data popover-budget-negociado'><strong></strong>% <small>Negociado</small></div>
        <div class='popover-budget-data popover-budget-otros'><strong></strong>% <small>Otros</small></div>")


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
    data = d3.select(d3.event.target.parentNode).datum()
    # setup popover for companies
    if @$el.attr('id') == 'companies-chart'
      amountAlone = data.items[1].x0
      amountTotal = data.items[1].x1
      @$tooltip.find('.popover-budget-alone strong').html(Math.round(100*amountAlone/amountTotal).toLocaleString('es-ES'))
      @$tooltip.find('.popover-budget-ute strong').html(Math.round(100*(amountTotal-amountAlone)/amountTotal).toLocaleString('es-ES'))
    # setup popover for administrations
    else
      amountAbierto   = data.items.filter( (d) -> return d.name == 'Abierto' )[0]
      amountNegociado = data.items.filter( (d) -> return d.name == 'Negociado' )[0]
      amountOtros     = data.items.filter( (d) -> return d.name == 'Otros' )[0]
      amountAbierto   = if amountAbierto then amountAbierto.x1-amountAbierto.x0 else 0
      amountNegociado = if amountNegociado then amountNegociado.x1-amountNegociado.x0 else 0
      amountOtros     = if amountOtros then amountOtros.x1-amountOtros.x0 else 0
      amountTotal     = amountAbierto + amountNegociado + amountOtros
      @setAmount 'abierto', amountAbierto, amountTotal
      @setAmount 'negociado', amountNegociado, amountTotal
      @setAmount 'otros', amountOtros, amountTotal
    # set common properties
    @$tooltip.find('.popover-title').html(data.key)
    @$tooltip.find('.popover-budget strong').html(Math.floor(amountTotal/1000000).toLocaleString('es-ES'))
    @$tooltip.show()

  @onMouseMove: =>
    offset = @$el.offset()
    @$tooltip.css
      left: d3.event.pageX - offset.left - @$tooltip.width()*0.5
      top:  d3.event.pageY - offset.top - @$tooltip.height() - 12

  @onMouseOut: =>
    @$tooltip.hide()

  @setAmount: (id, amount, total) ->
    if amount > 0
      val = 100*amount/total
      val = if val > 1 then Math.round(val) else val.toFixed(2)
      @$tooltip.find('.popover-budget-'+id+' strong').html(val.toLocaleString('es-ES'))
      @$tooltip.find('.popover-budget-'+id).show()
    else
      @$tooltip.find('.popover-budget-'+id).hide()

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
