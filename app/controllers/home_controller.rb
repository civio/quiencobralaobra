class HomeController < ApplicationController

  def index
    @articles = (can? :manage, Article) ? Article.where( featured: true ) : Article.published.where( featured: true )
    @articles_highlighted = @articles.where( highlighted: true )
    @articles = @articles.where( highlighted: false )

    @gallery_picture = [
    	'accesos-puerto-barcelona.jpg',		
    	'estacion-la-sagrera-barcelona-2.jpg',	
    	'puente-rande-pontevedra.jpg',
		'acessos-bilbao.jpg',			
		'hernialde-zizurkil-gipuzkoa.jpg',		
		'soterramiento-ferrocarril-logrono.jpg',
		'autovia-regueron-murcia.jpg',		
		'hospital-cuenca.jpg',			
		'tanque-gas-puerto-bilbao.jpg',
		'complejo-ferroviario-valladolid.jpg',	
		'hospital-guadalajara.jpg',		
		'tren-aeropuerto-barcelona.jpg',
		'estacion-atocha-madrid.jpg',		
		'linea-9-metro-madrid-1.jpg',		
		'tunel-sorbas-almeria.jpg',
		'estacion-la-sagrera-barcelona-1.jpg',	
		'linea-9-metro-madrid-2.jpg'
    ].sample
  end
end
