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
    
    console.log 'setup', @width

    # Setup x function
    @x = d3.scale.linear()
      .domain([0, d3.max(@data)])
      .range([0, @width])

    # Setup svg
    @svg = d3.select('#home-chart').append('svg')
      .attr('class', 'chart')
      .attr('width', @width)
      .attr('height', @barHeight * @data.length)

  # Draw function
  @draw: ->
    
    # Create bars
    @bars = @svg.selectAll('g')
      .data(@data)
    .enter().append('g')
      .attr('transform', (d, i) => return 'translate(0,' + i * @barHeight + ')')

    # Append Rect to Bars
    @bars.append('rect')
      .attr('width', @x)
      .attr('height', @barHeight-1)

    # Append Text to Bars
    @bars.append('text')
      .attr('x', (d) => return @x(d)-3 )
      .attr('y', @barHeight*0.5 )
      .attr('dy', '.35em')
      .text((d) -> return d )


  # Resize function
  @resize: (w) ->
    # Skip if width value doesn't change
    if @width == w
      return
    
    # Update values
    @width = w
    @x.range([0, @width])
    @svg.attr('width', @width)
    
    # Update Bars widths
    @bars.selectAll('rect')
      .attr('width', @x)
    @bars.selectAll('text')
      .attr('x', (d) => return @x(d)-3 )


  # Public Resize method 
  resize: (w) ->
    BarChart.resize(w)
