require 'bigdecimal'

class Award < ActiveRecord::Base
  belongs_to :public_body
  belongs_to :bidder

  def self.load_from_hash(properties)
    # Load the data only if it's a public works award
    # FIXME: Let's load the whole thing temporarily and use the database to check
    # whether we're doing it correctly.
    # return unless properties['[QCLO] Es Obra Pública']=='S'

    # Find or create related entities
    public_body = PublicBody.where(name: properties['Entidad adjudicadora - Organismo']).first_or_create
    bidder = Bidder.where(name: properties['Formalización del contrato - Contratista']).first_or_create

    # Read amount and store it in cents. We are being extra careful here not to change any amount
    # even in one cent. That's why we are avoiding floats, not a good fit when exact precision is needed.
    amount = BigDecimal.new(properties['Análisis - Importe'])*100

    # Store the award
    Award.create!({
        public_body: public_body,
        bidder: bidder, 
        award_date: properties['[QCLO] Fecha de adjudicación'],
        category: properties['Análisis - Tipo'],
        process_type: properties['Análisis - Procedimiento'],
        process_track: properties['Análisis - Tramitación'],
        amount: amount,
        properties: properties
      })
  end
end