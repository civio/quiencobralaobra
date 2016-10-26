class window.TreemapChart


  constructor: (id, data, options) ->
    # Setup & draw chart
    TreemapChart.setup id, data, options
    TreemapChart.draw()


  # Setup funcion
  @setup: (id, data, options) ->

    # Setup default vars
    @options    = options || {}
    @options.id = id
    @data       = data || []

    # get main element
    @$el = $('#'+@options.id)
   
    # get tooltip 
    @$tooltip  = @$popover = @$el.find('.popover')

    d3.formatDefaultLocale {thousands: '.', grouping: [3]}
    @budgetFormat = d3.format(',d')

    @colorScale = d3.scaleLinear()
      .domain d3.extent(@data, (d) -> return d.amount)
      .range ['#f27649', '#f25f29']

    @fontSizeScale = d3.scaleLinear()
      .domain [0, 1]
      .range [0.75, 3]

    # get sizes
    @getSizes()

    # Setup treemap & root
    @treemap = d3.treemap()
      .size     [@width, @height]
      .padding  1
      .round    true

    stratify = d3.stratify()
      .parentId (d) -> return d.id.substring(0, d.id.lastIndexOf('.'))

    @root = stratify(@data)
      .sum (d) -> return d.amount
      .sort (a, b) -> return b.value - a.value

    @treemap @root


  # Draw function
  @draw: (id) =>

    d3.select('#'+@options.id)
      .selectAll('.node')
      .data @root.leaves()
      .enter().append('div')
        .attr  'class', 'node'
        #.attr  'title', (d) -> return d.id + '\n' + format(d.value)
        .style 'left', (d) -> return d.x0 + 'px'
        .style 'top', (d) -> return d.y0 + 'px'
        .style 'width', (d) -> return d.x1 - d.x0 + 'px'
        .style 'height', (d) -> return d.y1 - d.y0 + 'px'
        # .style 'background', (d) => 
        #   while (d.depth > 1)
        #     d = d.parent
        #   return @color(d.id)
        .style 'background', (d) => return @colorScale(d.value)
        .on 'mouseover', @onMouseOver
        .on 'mousemove', @onMouseMove
        .on 'mouseout',  @onMouseOut
        .call @setLabels

  @setLabels: (selection) =>
    selection
      # filter rects with dimensions greather than 50px
      .filter (d) -> return d.x1-d.x0 > 60 && d.y1-d.y0 > 60
      .append('div')
        .attr 'class', 'node-label'
        .append('p')
          .text (d) -> return if d.data.entity.length < 50 then d.data.entity else d.data.entity.substring(0,50)+'...'
          .style 'font-size', @getFontSize

  # Get width & height
  @getSizes: ->

    @width   = @$el.width()

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


  # Resize event handler
  @resize: =>

    if @width != @$el.width()

      # update sizes
      @getSizes()

      # update treemap with new sizes
      @treemap.size [@width, @height]
      @treemap @root

      # update nodes dimensions
      d3.select('#'+@options.id)
        .selectAll('.node')
          .style 'left', (d) -> return d.x0 + 'px'
          .style 'top', (d) -> return d.y0 + 'px'
          .style 'width', (d) -> return d.x1 - d.x0 + 'px'
          .style 'height', (d) -> return d.y1 - d.y0 + 'px'


  @onMouseOver: (e) =>
    # Setup content
    @$tooltip.find('.popover-area').html e.data.description
    @$tooltip.find('.popover-title').html           e.data.entity
    @$tooltip.find('.popover-budget strong').html   @budgetFormat(e.data.amount)
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


  @getFontSize: (d) =>
    size = Math.sqrt( (d.x1-d.x0) * (d.y1-d.y0) / (@width * @height) )
    return @fontSizeScale(size)+'rem'


  # Public Resize method 
  resize: ->
    TreemapChart.resize()
