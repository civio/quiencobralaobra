require 'bigdecimal'

class Award < ActiveRecord::Base
  belongs_to :public_body
  belongs_to :bidder

  def self.load_from_hash(properties)
    # Find or create related public body entity
    public_body = PublicBody.where(name: properties['[QCLO] Entidad adjudicadora - Nombre']).first_or_create
    populate_related_entity_attribute(public_body, :body_type, properties['[QCLO] Entidad adjudicadora - Tipo'])

    # Same with the bidder
    bidder = Bidder.where(name: properties['[QCLO] Contratista - Limpio']).first_or_create
    populate_related_entity_attribute(bidder, :group, properties['[QCLO] Contratista - Grupo'])
    populate_related_entity_attribute(bidder, :acronym, properties['[QCLO] Contratista - Acrónimo'])

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

  private

  def self.populate_related_entity_attribute(entity, field, value)
    return if value.blank? # Nothing to do

    # If we didn't have information beforehand it's simple, modify and save
    if entity[field].blank?
      entity[field] = value
      entity.save!
      return
    end

    # But if we had, is it consistent? If it isn't print a warning
    if entity[field]!=value
      puts "Warning: for '#{entity.name}', was '#{entity[field]}', now '#{value}'. Skipping..."
    end
  end
end