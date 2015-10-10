# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

PublicBody.delete_all
PublicBody.create([{ name: 'Ministerio de Agricultura'}, { name: 'Ministerio de Cultura' }])

Bidder.delete_all
Bidder.create([{ name: 'Iberdrola'}, { name: 'FCC' }, { name: 'Microsoft' }])
