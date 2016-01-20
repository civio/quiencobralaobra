class window.BarChart

  constructor: (options) ->
    options   = options || {}    
    BarChart.setup options
    BarChart.draw()


  # Setup funcion
  @setup: (options) ->
    # Setup default vars
    @width     = options.width || 720
    @barHeight = options.barHeight || 24
    @data      = options.data || []

    @contOffset = $('#home-chart').offset()

    console.log 'setup', @width

    # Setup x function
    @x = d3.scale.linear()
      .domain([0, d3.max(@data, (d) -> return d.total)])
      .rangeRound([0, @width])

    # Setup svg
    @svg = d3.select('#home-chart').append('svg')
      .attr('class', 'chart')
      .attr('width', @width)
      .attr('height', 2 * @barHeight * @data.length)

    # Add tooltip 
    @tooltip = d3.select('#home-chart')
      .append('div')
        .attr('id', 'chart-tooltip')


  # Draw function
  @draw: ->
    
    # Create bars
    @bars = @svg.selectAll('g')
      .data(@data)
    .enter().append('g')
      .attr('transform', (d, i) => return 'translate(0,' + 2 * i * @barHeight + ')')

    # Append Rect to Bars
    @bars.selectAll('rect')
      .data((d) -> return d.procedimientos)
    .enter().append('rect')
      .attr('class', (d) -> return d.name.toLowerCase().split(' ').join('-') )
      .attr('x', (d) => return @x(d.x0) )
      .attr('width', (d) => return @x(d.x1) - @x(d.x0) )
      .attr('height', @barHeight-1)
      .on('mouseover', (d) =>
        console.log d.name, d.x1 - d.x0
        @tooltip.html( '<strong>'+d.name + '</strong><br/>' + (d.x1 - d.x0).toLocaleString('es-ES') + ' €')
        @tooltip.classed('active', true)
      )
      .on('mousemove', (d) =>
        console.log d, $('#home-chart').offset()
        @tooltip
          .style('top', (d3.event.pageY-@contOffset.top+15)+'px')
          .style('left', (d3.event.pageX-@contOffset.left+10)+'px')
      )
      .on('mouseout', (d) =>
        console.log 'mouseout'
        @tooltip.classed('active', false)
      )

    # Append text with amount to Bars
    @bars.append('text')
      .attr('class', 'amount')
      .attr('x', 6) #(d) => return @x(d.amount)-6 )
      .attr('y', @barHeight * 0.5 )
      .attr('dy', '.35em')
      .text((d) -> return d.total.toLocaleString('es-ES') + ' €' )

    # Append Label with 'contratista' to Bars
    @bars.append('text')
      .attr('class', 'label')
      .attr('x', 0 )
      .attr('y', @barHeight )
      .attr('dy', '1em')
      .text((d) -> return d.key )


  # Resize function
  @resize: (w) ->
    # Skip if width value doesn't change
    if @width == w
      return

    # Update values
    @width = w
    @x.range([0, @width])
    @svg.attr('width', @width)
    @contOffset = $('#home-chart').offset()
    
    # Update Bars widths
    @bars.selectAll('rect')
      .attr('width', (d) => return @x(d.amount) )
      .attr('x', (d) => return @x(d.amount)-6 )


  # Public Resize method 
  resize: (w) ->
    BarChart.resize(w)
