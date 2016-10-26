require 'bigdecimal'

class Award < ActiveRecord::Base
  belongs_to :public_body
  belongs_to :bidder

  def self.load_from_hash(properties)
    # Find or create related entities
    public_body = PublicBody.where(name: properties['[QCLO] Entidad adjudicadora - Nombre']).first_or_create
    bidder = Bidder.where(name: properties['[QCLO] Contratista - Grupo']).first_or_create

    # Read amount and store it in cents. We are being extra careful here not to change any amount
    # even in one cent. That's why we are avoiding floats, not a good fit when exact precision is needed.
    amount = BigDecimal.new(properties['[QCLO] Importe o canon de adjudicación - Limpio'])*100

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