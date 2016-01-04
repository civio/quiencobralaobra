require 'csv'

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

  desc "Import list of awards"
  task :import_awards, [:filename] => :environment do |t, args|
    def row_to_hash(row, column_names)
      properties = {}
      row.each_with_index {|value, position| properties[column_names[position]] = value }
      properties
    end

    def load_award(properties)
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

    column_names = nil
    Award.delete_all
    Bidder.delete_all
    PublicBody.delete_all
    CSV.read(args[:filename]).each_with_index do |row, i|
      if i==0
        # The first row contains the column names
        column_names = row
      else
        # We convert the row to a hash with named properties
        properties = row_to_hash(row, column_names)

        # Load the data if it's a public works award
        load_award(properties) if properties['[QCLO] Es Obra Pública']=='S'
      end
    end
  end
end
