class DataController < ApplicationController

  # GET /data/grupos-constructores
  def grupos_constructores
    query = <<-EOQ
      WITH
      totals_awarded_to_group_companies_or_fully_controlled_utes AS
      (
        SELECT
          bidders.group,
          bidders.slug,
          sum(awards.amount) as direct
        FROM
          bidders
            INNER JOIN awards
              ON bidders.id = awards.bidder_id
        GROUP BY
          bidders.group,
          bidders.slug
        HAVING
          bidders.group NOT IN
          (
            SELECT
              ute
            FROM
              ute_companies_mappings
          )
      ),
      totals_awarded_to_participated_but_not_fully_controlled_utes AS
      (
        WITH
        awarded_utes_with_group AS
        (
          WITH
          awarded_utes AS
          (
            SELECT
              bidders.group as ute,
              ute_companies_mappings.company,
              sum(awards.amount) as sum
            FROM
              bidders
                INNER JOIN awards
                  ON bidders.id = awards.bidder_id
                INNER JOIN ute_companies_mappings
                  ON bidders.group = ute_companies_mappings.ute
            GROUP BY
                bidders.group,
                ute_companies_mappings.company
          )
          SELECT
            awarded_utes.ute,
            awarded_utes.company,
            awarded_utes.sum,
            bidders.group
          FROM
            awarded_utes
            INNER JOIN bidders
              ON awarded_utes.company = bidders.name
        )
        SELECT
          "group",
          sum("sum") as on_utes
        FROM
          awarded_utes_with_group
        GROUP BY
          "group"
      )
      SELECT
        totals_awarded_to_group_companies_or_fully_controlled_utes.group as grupo,
        slug,
        direct as importe_grupo,
        COALESCE(on_utes, 0) as importe_utes,
        (direct + COALESCE(on_utes, 0)) as total
      FROM
        totals_awarded_to_group_companies_or_fully_controlled_utes
          LEFT JOIN totals_awarded_to_participated_but_not_fully_controlled_utes
            ON totals_awarded_to_group_companies_or_fully_controlled_utes.group = totals_awarded_to_participated_but_not_fully_controlled_utes.group
      ORDER BY
        total DESC
      LIMIT
        10;
    EOQ
    @results = ActiveRecord::Base.connection.execute(query)
    render json: @results
  end

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

  # GET /data/administraciones
  def administraciones
    query = "SELECT 
      properties -> 'Departamento' AS administracion,
      process_type AS procedimiento,
      SUM(amount) AS importe,
      COUNT(amount) AS contratos
    FROM AWARDS
    WHERE
      properties -> 'Análisis - Tipo' = 'Obras' AND
      properties -> 'Departamento' <> '' AND
      process_type <> '' AND
      amount IS NOT NULL
    GROUP BY administracion, procedimiento
    ORDER BY importe DESC"
    @results = PublicBody.connection.execute(query)
    render json: @results
  end
end
