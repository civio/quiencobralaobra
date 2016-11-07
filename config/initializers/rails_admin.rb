# RailsAdmin config file. Generated on July 29, 2013 23:52
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Quién Cobra La Obra', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_user } # auto-generated

  # Authorization via CanCan
  RailsAdmin.config do |config|
    config.authorize_with :cancan
  end

  # Extra actions:
  #  - toggle: to toggle booleans from index view, see rails_admin_toggleable
  config.actions do
    dashboard
    index
    new
    show
    edit
    delete
    show_in_app
  end

  # Add our own custom admin stuff
  # config.navigation_static_label = "Extras"
  # config.navigation_static_links = {
  # }

  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  # config.excluded_models = ['Entity', 'User']

  # Include specific models (exclude the others):
  # config.included_models = ['Entity', 'User']

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:

  config.model 'User' do  
    object_label_method :name
  end

  config.model 'Article' do
    list do
      field :published
      field :title
      field :author
      field :publication_date
    end

    edit do
      group :basic_info do
        label "Content"
        field :title
        field :lead
        field :content, :ck_editor do 
          help 'Puedes escribir HTML aquí.'
        end
        field :author
        field :mentions_in_content do
          read_only true
        end
      end
      group :photo do
        label "Photo"
        field :photo, :carrierwave
        field :photo_footer
        field :photo_credit
        field :photo_credit_link
      end
      group :internal do
        label "Internal"
        field :published
        field :featured
        field :highlighted
        field :slug do
          help 'Leave blank for the URL slug to be auto-generated'
        end
        field :notes
        field :publication_date do
          default_value do
            Time.now
          end
        end
        field :updated_at do
          read_only true
        end
      end
    end
  end

end
