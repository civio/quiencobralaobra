# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
User.create!( name: 'Admin', 
              email: 'admin@quiencobralaobra.es', 
              password: 'password', 
              password_confirmation: 'password')


def create_mentions(article, mentionees)
  mentionees.map{|mentionee| Mention.create!({ article: article, mentionee: mentionee }) }
end

Article.delete_all
first_article = Article.create!({
    title: 'Economía oculta los nombres de las tabaqueras con las que se reúne para hablar sobre la Directiva de Productos del Tabaco',
    publication_date: '12/9/2015'
  })
# first_article.mentions_in_content = create_mentions(first_article, [first_body, first_bidder])

second_article = Article.create!({
    title: 'La inversión en obra pública',
    publication_date: '20/9/2015'
  })
# second_article.mentions_in_content = create_mentions(first_article, [first_bidder, second_bidder, third_bidder])

third_article = Article.create!({
    title: 'Negociado versus concurso',
    publication_date: '4/10/2015'
  })
# third_article.mentions_in_content = create_mentions(first_article, [first_body, second_body])

Article.create!({
    title: 'Lo que siempre quisiste saber sobre la contratación pública',
    publication_date: '14/10/2015'
  })

