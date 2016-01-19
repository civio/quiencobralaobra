homeChart = null

$(document).ready ->
  console.log 'Hello!'
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
      # loop through each 'contratista'
      contratistas.forEach (contratista) ->
        contratista.amount = 0
        # sum all amounts from each 'procedimiento'
        contratista.values.forEach (procedimiento) ->
          contratista.amount += +procedimiento.values[0].importe
      # Sort by total amount
      contratistas.sort (a, b) ->
        return d3.descending(a.amount, b.amount)
      # Truncate array to 12 first elements
      contratistas.splice 12, contratistas.length

      procedimientos = d3.nest()
        .key((d) -> return d.procedimiento)
        .entries(json)

      console.dir procedimientos
      homeChart = new BarChart {data: contratistas, width: $('#home-chart').width()}
      console.log 'homeChart', homeChart

  $(window).resize ->
    if homeChart
      console.log 'resize'
      homeChart.resize $('#home-chart').width()
