homeChart = null

$(document).ready ->

  if $('#home-chart').length

    d3.json '/data/empresas', (error, json) ->
      if error
        return console.warn(error)

      # Consolidate 'procedimiento' values
      json.forEach (value) ->
        value.procedimiento = if value.procedimiento.toLowerCase().indexOf('abierto') != -1 then 'Abierto' else 'Negociado'
      console.dir json  

      # create a nested array with 'contratista' / 'procemiento' / 'data' structure
      contratistas = d3.nest()
        .key((d) -> return d.contratista)
        .key((d) -> return d.procedimiento)
        .entries(json)

      # Add procedimientos attribute to contratistas array
      contratistas.forEach (contratista) ->
        total = 0
        contratista.procedimientos = contratista.values.map (procedimiento) ->
          procedimiento.total = 0
          procedimiento.values.forEach (d) ->
            procedimiento.total += +d.importe
          return { 
            name: procedimiento.key
            x0:   total
            x1:   total += procedimiento.total
          }
        contratista.total = total

      console.dir contratistas

      # Sort contratistas by total amount
      contratistas.sort (a, b) ->
        return d3.descending(a.total, b.total)

      # Truncate array to 12 first elements
      contratistas.splice 12, contratistas.length

      homeChart = new BarChart {data: contratistas, width: $('#home-chart').width()}

  $(window).resize ->
    if homeChart
      console.log 'resize'
      homeChart.resize $('#home-chart').width()
