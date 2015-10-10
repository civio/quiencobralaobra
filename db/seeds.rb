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

Article.delete_all
Article.create({ 
    title: 'Economía oculta los nombres de las tabaqueras con las que se reúne para hablar sobre la Directiva de Productos del Tabaco',
    publication_date: '12/9/2015'
  })
Article.create({ 
    title: 'La inversión en obra pública',
    publication_date: '20/9/2015'
  })
Article.create({ 
    title: 'Negociado versus concurso',
    publication_date: '4/10/2015'
  })
Article.create({ 
    title: 'Lo que siempre quisiste saber sobre la contratación pública',
    publication_date: '14/10/2015'
  })

