class Award < ActiveRecord::Base
  belongs_to :public_body
  belongs_to :bidder

  def self.load_from_hash(properties)
    public_body = PublicBody.where(name: properties['Entidad adjudicadora - Organismo']).first_or_create
    bidder = Bidder.where(name: properties['Formalización del contrato - Contratista']).first_or_create
    Award.create!({
        public_body: public_body,
        bidder: bidder, 
        award_date: properties['[QCLO] Fecha de adjudicación'],
        category: properties['Análisis - Tipo'],
        process_type: properties['Análisis - Procedimiento'],
        process_track: properties['Análisis - Tramitación'],
        amount: properties['Análisis - Importe']*100, # in cents
        properties: properties
      })
  end
end