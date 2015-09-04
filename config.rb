###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Activate Directory Indexes extension
activate :directory_indexes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

helpers do
  # get url from .yml title data
  def get_url(title, type)
    data[type].each do |entity|
      if entity.name == title 
        return entity.url
      end
    end
  end
end

# Generate html files for posts
data.posts.each do |post|
  proxy "/articulos/#{post.url}.html", "articulo.html", :locals => { :title => post.title }, :ignore => true
end

# Generate html files for companies
data.companies.each do |entity|
  proxy "/empresas/#{entity.url}.html", "entity.html", :locals => { :title => entity.name }, :ignore => true
end

# Generate html files for edministrations
data.administrations.each do |entity|
  proxy "/administraciones/#{entity.url}.html", "entity.html", :locals => { :title => entity.name }, :ignore => true
end

# Generate html files for contracts
data.contracts.each_with_index do |contract, i|
  proxy "/contratos/#{i}.html", "contrato.html", :locals => { :data => contract }, :ignore => true
end
