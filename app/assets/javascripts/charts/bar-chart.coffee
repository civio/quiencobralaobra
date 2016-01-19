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
      .domain([0, d3.max(@data, (d) -> return d.amount)])
      .range([0, @width])

    # Setup svg
    @svg = d3.select('#home-chart').append('svg')
      .attr('class', 'chart')
      .attr('width', @width)
      .attr('height', 2 * @barHeight * @data.length)

  # Draw function
  @draw: ->
    
    # Create bars
    @bars = @svg.selectAll('g')
      .data(@data)
    .enter().append('g')
      .attr('transform', (d, i) => return 'translate(0,' + 2 * i * @barHeight + ')')

    @data.forEach (d) ->
      console.log d  

    # Append Rect to Bars
    @bars.append('rect')
      .attr('class', 'bar')
      .attr('width', (d) => return @x(d.amount) )
      .attr('height', @barHeight-1)

    # state.selectAll("rect")
    #   .data(function(d) { return d.ages; })
    # .enter().append("rect")
    #   .attr("width", x.rangeBand())
    #   .attr("y", function(d) { return y(d.y1); })
    #   .attr("height", function(d) { return y(d.y0) - y(d.y1); })
    #   .style("fill", function(d) { return color(d.name); });


    # Append text with amount to Bars
    @bars.append('text')
      .attr('class', 'amount')
      .attr('x', 6) #(d) => return @x(d.amount)-6 )
      .attr('y', @barHeight * 0.5 )
      .attr('dy', '.35em')
      .text((d) -> return d.amount.toLocaleString('es-ES') + ' €' )

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
    
    # Update Bars widths
    @bars.selectAll('rect')
      .attr('width', (d) => return @x(d.amount) )
    #@bars.selectAll('.amount')
    #  .attr('x', (d) => return @x(d.amount)-6 )


  # Public Resize method 
  resize: (w) ->
    BarChart.resize(w)
