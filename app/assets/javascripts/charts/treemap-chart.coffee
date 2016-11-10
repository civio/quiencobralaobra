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
    @options.utes = true
    @data       = data || []

    # get main element
    @$el = $('#'+@options.id)
   
    # get tooltip 
    @$tooltip = @$el.find('.popover')

    d3.formatDefaultLocale {thousands: '.', grouping: [3]}
    @budgetFormat = d3.format(',d')

    # @colorScale = d3.scaleLinear()
    #   .domain d3.extent(@data, @getAmount)
    #   .range ['#f27649', '#f25f29']

    @fontSizeScale = d3.scaleLinear()
      .domain [0, 1]
      .range [0.75, 3]

    @total = d3.sum @data, @getAmount

    # filter data to unify small parts in a 'Others' item
    # other = 0
    # @data.forEach (d, i) =>
    #   if d.amount/@total < 0.001
    #     d.remove = true
    #     other += d.amount
    # if other > 0
    #   @data = @data.filter (d) -> return d.remove != true
    #   @data.push 
    #     id: 'ob.other'
    #     entity: 'Otros'
    #     amount: other
    #     type: 'others'

    # get sizes
    @getSizes()

    # Setup treemap & root
    @treemap = d3.treemap()
      .size     [@width, @height]
      .padding  1
      .round    true

    @stratify = d3.stratify()
      .parentId (d) -> return d.id.substring(0, d.id.lastIndexOf('.'))

    @root = @stratify(@data)
      .sum @getAmount
      .sort (a, b) -> return b.value - a.value

    @treemap @root

    @el = d3.select('#'+@options.id)


  # Draw function
  @draw: ->
    @el.selectAll('.node').remove()

    @el.selectAll('.node')
      .data @root.leaves()
      .enter()
        .append('div')
          .attr  'class', (d) -> return if d.data.type then 'node '+d.data.type else 'node'
          .call @setDimensions
          .on 'mouseover', @onMouseOver
          .on 'mousemove', @onMouseMove
          .on 'mouseout',  @onMouseOut
          .call @setLabels


  @update: (state) =>
    # update utes state
    @options.utes = state

    # Update total amount, root & treemap
    @total = d3.sum @data, @getAmount
    @root.sum @getAmount
    @root.sort (a, b) -> return b.value - a.value
    @treemap @root

    # redraw
    @draw()


  @setDimensions: (selection) =>
    selection
      .style 'left', (d) -> return d.x0 + 'px'
      .style 'top', (d) -> return d.y0 + 'px'
      .style 'width', (d) -> return d.x1 - d.x0 + 'px'
      .style 'height', (d) -> return d.y1 - d.y0 + 'px'

  @setLabels: (selection) =>
    selection
      # filter rects with dimensions greather than 50px
      .filter (d) -> return d.x1-d.x0 > 55 && d.y1-d.y0 > 55
      .append('div')
        .attr 'class', 'node-label'
        .append('p')
          .text (d) -> return if d.data.entity.length < 50 then d.data.entity else d.data.entity.substring(0,50)+'...'
          .style 'font-size', @getFontSize

  @getAmount: (d) =>
    return if @options.utes == true then d.amountUTE else d.amount

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
    t = d3.transition()
      .duration 150

    @el.selectAll('.node')
      .transition t
      .style 'opacity', 0.5
    d3.select(d3.event.currentTarget)
      .interrupt()
      .style 'opacity', 1

    # Setup content
    @$tooltip.find('.popover-title').html              e.data.entity
    @$tooltip.find('.popover-budget strong').html      @budgetFormat(e.value)
    @$tooltip.find('.popover-budget .percentage').html '('+(100*e.value/@total).toFixed(1)+'%)'
    
    # Show popover
    @$tooltip.show()

    # Trigger entity-over event
    @$el.trigger 'entity-over', e.data.id.split('.').slice(1)


  @onMouseMove: (e) =>
    # get element offset
    offset = @$el.offset()
    # Setup popover position
    @$tooltip.css
      left: d3.event.pageX - offset.left - @$tooltip.width()*0.5
      top:  d3.event.pageY - offset.top - @$tooltip.height() - 12


  @onMouseOut: (e) =>
    t = d3.transition()
      .duration 200
    @el.selectAll('.node')
      .transition t
      .style 'opacity', 1
    # Hide popover
    @$tooltip.hide()

     # Trigger entity-out event
    @$el.trigger 'entity-out'


  @getFontSize: (d) =>
    size = Math.sqrt( (d.x1-d.x0) * (d.y1-d.y0) / (@width * @height) )
    return @fontSizeScale(size)+'rem'


  # Public Resize method 
  resize: ->
    TreemapChart.resize()

  update: (state) ->
    TreemapChart.update(state)

  el: ->
    return TreemapChart.$el
