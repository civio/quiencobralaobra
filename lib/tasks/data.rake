require 'csv'

namespace :data do
  desc "Import list of CPV codes"
  task import_cpv: :environment do
    CpvTerm.delete_all
    CSV.read('db/cpv_codes.csv').each do |row|
      next if row[0].start_with?('#') or row[0].empty?
      CpvTerm.create!(code: row[0], description: row[1])
    end
  end

end
