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

  # GET /data/administraciones
  def administraciones
    query = <<-EOQ
      WITH public_bodies_per_process_type AS (
        SELECT
          public_bodies.name AS administracion,
          public_bodies.slug,
          awards.process_type AS procedimiento,
          SUM(awards.amount) AS importe
        FROM awards
          INNER JOIN public_bodies
            ON awards.public_body_id = public_bodies.id
        WHERE
          properties -> 'Análisis - Tipo' = 'Obras' AND
          process_type <> '' AND
          amount IS NOT NULL
        GROUP BY
          administracion,
          public_bodies.slug,
          procedimiento
        ORDER BY importe DESC
      )

      SELECT *
      FROM public_bodies_per_process_type
      WHERE administracion IN (
        SELECT administracion
        FROM public_bodies_per_process_type
        GROUP BY administracion
        ORDER BY sum(importe) DESC
        LIMIT 10
      );
    EOQ
    @results = ActiveRecord::Base.connection.execute(query)
    render json: @results
  end
end
