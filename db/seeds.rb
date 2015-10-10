# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

PublicBody.delete_all
first_body = PublicBody.create!({ name: 'Ministerio de Agricultura'})
second_body = PublicBody.create!({ name: 'Ministerio de Cultura' })

Bidder.delete_all
first_bidder = Bidder.create!({ name: 'Iberdrola'})
second_bidder =Bidder.create!({ name: 'FCC' })
third_bidder = Bidder.create!({ name: 'Microsoft' })

Award.delete_all
Award.create!({ public_body: first_body, bidder: first_bidder, award_date: '12/8/2015', amount: 1E6 })
Award.create!({ public_body: first_body, bidder: second_bidder, award_date: '19/8/2015', amount: 2E6 })
Award.create!({ public_body: first_body, bidder: third_bidder, award_date: '23/8/2015', amount: 3E6 })
Award.create!({ public_body: second_body, bidder: first_bidder, award_date: '12/9/2015', amount: 4E6 })
Award.create!({ public_body: second_body, bidder: second_bidder, award_date: '20/9/2015', amount: 5E6 })

def create_mentions(article, mentionees)
  mentionees.map{|mentionee| Mention.create!({ article: article, mentionee: mentionee }) }
end

Article.delete_all
first_article = Article.create!({
    title: 'Economía oculta los nombres de las tabaqueras con las que se reúne para hablar sobre la Directiva de Productos del Tabaco',
    publication_date: '12/9/2015'
  })
first_article.mentions_in_content = create_mentions(first_article, [first_body, first_bidder])

second_article = Article.create!({
    title: 'La inversión en obra pública',
    publication_date: '20/9/2015'
  })
second_article.mentions_in_content = create_mentions(first_article, [first_bidder, second_bidder, third_bidder])

third_article = Article.create!({
    title: 'Negociado versus concurso',
    publication_date: '4/10/2015'
  })
third_article.mentions_in_content = create_mentions(first_article, [first_body, second_body])

Article.create!({
    title: 'Lo que siempre quisiste saber sobre la contratación pública',
    publication_date: '14/10/2015'
  })

