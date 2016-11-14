require 'csv'

def self.load_from_hash(properties)
  # Find or create related public body entity
  public_body = PublicBody.where(name: properties['[QCLO] Entidad adjudicadora - Nombre']).first_or_create
  populate_related_entity_attribute(public_body, :body_type, properties['[QCLO] Entidad adjudicadora - Tipo'])

  # Same with the bidder
  bidder = Bidder.where(name: properties['[QCLO] Contratista - Limpio']).first_or_create
  populate_related_entity_attribute(bidder, :group, properties['[QCLO] Contratista - Grupo'])
  populate_related_entity_attribute(bidder, :acronym, properties['[QCLO] Contratista - Acrónimo'])
  populate_related_entity_attribute(bidder, :is_ute, properties['[QCLO] Es UTE']=='S')

  # Read amount and store it in cents. We are being extra careful here not to change any amount
  # even in one cent. That's why we are avoiding floats, not a good fit when exact precision is needed.
  amount = BigDecimal.new(properties['[QCLO] Importe o canon de adjudicación - Limpio'])*100

  # Store the award
  Award.create!({
      boe_id: properties['BOE ID'],
      public_body: public_body,
      bidder: bidder,
      description: properties['[QCLO] Descripción del objeto'],
      award_date: properties['[QCLO] Fecha de adjudicación'],
      category: properties['Análisis - Tipo'],
      process_type: properties['[QCLO] Procedimiento - Limpio'],
      process_track: properties['[QCLO] Tramitación - Limpio'],
      amount: amount,
      properties: properties
    })
end

# Fill additional fields of the related entities. Note that there's no guarantee the related info will be
# consistent or completely filled-up in the input data, that comes in denormalized. Hence the need
# to create the object just with the name, and populate it with further info in a later step.
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

namespace :data do
  desc "Import list of CPV codes"
  task import_cpv: :environment do
    CpvTerm.delete_all
    CSV.read('db/cpv_codes.csv').each do |row|
      next if row[0].start_with?('#') or row[0].empty?
      # Load the CPV term, ignoring the trailing control digit in the code, we don't care
      CpvTerm.create!(code: row[0].split('-')[0], description: row[1])
    end
  end

  desc "Import UTE-companies mapping"
  task import_utes: :environment do |t, args|
    UteCompaniesMapping.delete_all
    CSV.read('db/utes_mapping.csv').each do |row|
      next if row[0].start_with?('#') or row[0].empty?
      UteCompaniesMapping.create!(ute: row[0], company: row[1], group: row[2])

      # Some companies only win awards as members of an UTE, so they're not in the main
      # table of bidders, and we need to add them now.
      bidder = Bidder.where(name: row[1]).first_or_create
      populate_related_entity_attribute(bidder, :group, row[2])
      populate_related_entity_attribute(bidder, :is_ute, false)
    end
  end

  desc "Import list of awards"
  task :import_awards, [:filename] => :environment do |t, args|
    def row_to_hash(row, column_names)
      properties = {}
      row.each_with_index {|value, position| properties[column_names[position]] = value }
      properties
    end

    column_names = nil
    processed_records = 0
    Award.delete_all
    Bidder.delete_all
    PublicBody.delete_all
    CSV.read(args[:filename]).each_with_index do |row, i|
      if i==0
        # The first row contains the column names
        column_names = row
      else
        # We convert the row to a hash with named properties, and load it
        Award.load_from_hash(row_to_hash(row, column_names))
        processed_records += 1
      end
    end

    puts "#{processed_records} records processed successfully."
  end
end
