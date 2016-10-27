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

  desc "Import UTE-companies mapping"
  task import_utes: :environment do |t, args|
    UteCompaniesMapping.delete_all
    CSV.read('db/utes_mapping.csv').each do |row|
      next if row[0].start_with?('#') or row[0].empty?
      UteCompaniesMapping.create!(ute: row[0], company: row[1])
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
