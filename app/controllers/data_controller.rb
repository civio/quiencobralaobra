class DataController < ApplicationController
  
  # GET /data/empresas
  def empresas
    query = "SELECT 
       properties -> 'Formalización del contrato - Contratista' AS contratista,
       process_type AS procedimiento,
       SUM(amount) AS importe,
       COUNT(amount) AS contratos
   FROM AWARDS
   WHERE
       properties -> 'Análisis - Tipo' = 'Obras' AND
       properties -> 'Formalización del contrato - Contratista' <> '' AND
       process_type <> '' AND
       amount IS NOT NULL
   GROUP BY contratista, procedimiento
   ORDER BY importe DESC"
    @results = Award.connection.execute(query)
    render json: @results
  end
end
