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
        # We convert the row to a hash with named properties
        properties = row_to_hash(row, column_names)

        # Load the data if it's a public works award
        Award.load_from_hash(properties) if properties['[QCLO] Es Obra Pública']=='S'
        processed_records += 1
      end
    end

    puts "#{processed_records} records processed successfully."
  end
end
