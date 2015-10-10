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

end
