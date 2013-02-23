RailsAdmin.config do |config|


  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Posto', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  #config.current_user_method { current_web_user } # auto-generated
  config.authorize_with do
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == ENV["POSTO_ADMIN_PASSWORD"]
    end
  end

  config.main_app_name { ["Posto", "Admin"] }
  config.authenticate_with {} 

  # If you want to track changes on your models:
  # config.audit_with :history, 'WebUser'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'WebUser'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  # config.excluded_models = ['ActivityExecution', 'AddressApiResponse', 'AddressRequest', 'AddressRequestFacebookThread', 'AddressRequestState', 'ApiKey', 'App', 'CardCollectionEntry', 'CardDesign', 'CardImage', 'CardOrder', 'CardOrderState', 'CardPreviewComposition', 'CardPrinting', 'CardPrintingComposition', 'CardPrintingState', 'CardScan', 'CardScanAuthor', 'FacebookToken', 'FacebookTokenState', 'RecipientAddress', 'StripeCard', 'StripeCustomer', 'StripeCustomerCard', 'StripeCustomerCardState', 'Transaction', 'TransactionLineItem', 'User', 'UserLogin', 'UserProfile']

  # Include specific models (exclude the others):
  # config.included_models = ['ActivityExecution', 'AddressApiResponse', 'AddressRequest', 'AddressRequestFacebookThread', 'AddressRequestState', 'ApiKey', 'App', 'CardCollectionEntry', 'CardDesign', 'CardImage', 'CardOrder', 'CardOrderState', 'CardPreviewComposition', 'CardPrinting', 'CardPrintingComposition', 'CardPrintingState', 'CardScan', 'CardScanAuthor', 'FacebookToken', 'FacebookTokenState', 'RecipientAddress', 'StripeCard', 'StripeCustomer', 'StripeCustomerCard', 'StripeCustomerCardState', 'Transaction', 'TransactionLineItem', 'User', 'UserLogin', 'UserProfile']

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



  ###  ActivityExecution  ###

  # config.model 'ActivityExecution' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your activity_execution.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :activity_execution_id, :integer 
  #     configure :worker, :string 
  #     configure :method, :string 
  #     configure :arguments, :serialized 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  AddressApiResponse  ###

  # config.model 'AddressApiResponse' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your address_api_response.rb model definition

  #   # Found associations:

  #     configure :recipient_addresses, :has_many_association 

  #   # Found columns:

  #     configure :address_api_response_id, :integer 
  #     configure :response, :serialized 
  #     configure :api_type, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 
  #     configure :arguments, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  AddressRequest  ###

  # config.model 'AddressRequest' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your address_request.rb model definition

  #   # Found associations:

  #     configure :request_sender_user, :belongs_to_association 
  #     configure :request_recipient_user, :belongs_to_association 
  #     configure :app, :belongs_to_association 
  #     configure :address_request_states, :has_many_association 
  #     configure :address_request_facebook_threads, :has_many_association 

  #   # Found columns:

  #     configure :address_request_id, :integer 
  #     configure :request_sender_user_id, :integer         # Hidden 
  #     configure :request_recipient_user_id, :integer         # Hidden 
  #     configure :app_id, :integer         # Hidden 
  #     configure :address_request_medium, :string 
  #     configure :address_request_payload, :serialized 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  AddressRequestFacebookThread  ###

  # config.model 'AddressRequestFacebookThread' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your address_request_facebook_thread.rb model definition

  #   # Found associations:

  #     configure :address_request, :belongs_to_association 

  #   # Found columns:

  #     configure :address_request_facebook_thread_id, :integer 
  #     configure :address_request_id, :integer         # Hidden 
  #     configure :facebook_thread_id, :string 
  #     configure :thread_update_time, :datetime 
  #     configure :latest, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  AddressRequestState  ###

  # config.model 'AddressRequestState' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your address_request_state.rb model definition

  #   # Found associations:

  #     configure :address_request, :belongs_to_association 

  #   # Found columns:

  #     configure :address_request_state_id, :integer 
  #     configure :address_request_id, :integer         # Hidden 
  #     configure :state, :string 
  #     configure :latest, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  ApiKey  ###

  # config.model 'ApiKey' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your api_key.rb model definition

  #   # Found associations:

  #     configure :user, :belongs_to_association 

  #   # Found columns:

  #     configure :api_key_id, :integer 
  #     configure :user_id, :integer         # Hidden 
  #     configure :token, :string 
  #     configure :expires_at, :datetime 
  #     configure :latest, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  App  ###

  # config.model 'App' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your app.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :app_id, :integer 
  #     configure :name, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CardCollectionEntry  ###

  # config.model 'CardCollectionEntry' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your card_collection_entry.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :card_collection_entry_id, :integer 
  #     configure :card_design_id, :integer 
  #     configure :source_type, :string 
  #     configure :source_id, :integer 
  #     configure :app_id, :integer 
  #     configure :collection_type, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CardDesign  ###

  # config.model 'CardDesign' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your card_design.rb model definition

  #   # Found associations:

  #     configure :author_user, :belongs_to_association 
  #     configure :source_card_design, :belongs_to_association 
  #     configure :app, :belongs_to_association 
  #     configure :original_full_photo_image, :belongs_to_association 
  #     configure :composed_full_photo_image, :belongs_to_association 
  #     configure :edited_full_photo_image, :belongs_to_association 
  #     configure :card_orders, :has_many_association 
  #     configure :card_preview_compositions, :has_many_association 

  #   # Found columns:

  #     configure :card_design_id, :integer 
  #     configure :author_user_id, :integer         # Hidden 
  #     configure :source_card_design_id, :integer         # Hidden 
  #     configure :app_id, :integer         # Hidden 
  #     configure :design_type, :string 
  #     configure :top_caption, :string 
  #     configure :bottom_caption, :string 
  #     configure :top_caption_font_size, :string 
  #     configure :bottom_caption_font_size, :string 
  #     configure :original_full_photo_image_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 
  #     configure :composed_full_photo_image_id, :integer         # Hidden 
  #     configure :edited_full_photo_image_id, :integer         # Hidden 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CardImage  ###

  # config.model 'CardImage' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your card_image.rb model definition

  #   # Found associations:

  #     configure :author_user, :belongs_to_association 
  #     configure :app, :belongs_to_association 

  #   # Found columns:

  #     configure :card_image_id, :integer 
  #     configure :author_user_id, :integer         # Hidden 
  #     configure :app_id, :integer         # Hidden 
  #     configure :uuid, :string 
  #     configure :width, :integer 
  #     configure :height, :integer 
  #     configure :orientation, :string 
  #     configure :image_type, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 
  #     configure :image_format, :string 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CardOrder  ###

  # config.model 'CardOrder' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your card_order.rb model definition

  #   # Found associations:

  #     configure :order_sender_user, :belongs_to_association 
  #     configure :app, :belongs_to_association 
  #     configure :card_design, :belongs_to_association 
  #     configure :card_printings, :has_many_association 
  #     configure :card_order_states, :has_many_association 

  #   # Found columns:

  #     configure :card_order_id, :integer 
  #     configure :order_sender_user_id, :integer         # Hidden 
  #     configure :app_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 
  #     configure :quoted_total_price, :integer 
  #     configure :card_design_id, :integer         # Hidden 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CardOrderState  ###

  # config.model 'CardOrderState' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your card_order_state.rb model definition

  #   # Found associations:

  #     configure :card_order, :belongs_to_association 

  #   # Found columns:

  #     configure :card_order_state_id, :integer 
  #     configure :card_order_id, :integer         # Hidden 
  #     configure :state, :string 
  #     configure :latest, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CardPreviewComposition  ###

  # config.model 'CardPreviewComposition' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your card_preview_composition.rb model definition

  #   # Found associations:

  #     configure :card_design, :belongs_to_association 
  #     configure :card_preview_image, :belongs_to_association 

  #   # Found columns:

  #     configure :card_preview_composition_id, :integer 
  #     configure :card_design_id, :integer         # Hidden 
  #     configure :card_preview_image_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 
  #     configure :latest, :boolean 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CardPrinting  ###

  # config.model 'CardPrinting' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your card_printing.rb model definition

  #   # Found associations:

  #     configure :card_order, :belongs_to_association 
  #     configure :recipient_user, :belongs_to_association 
  #     configure :card_printing_compositions, :has_many_association 
  #     configure :card_printing_states, :has_many_association 

  #   # Found columns:

  #     configure :card_printing_id, :integer 
  #     configure :card_order_id, :integer         # Hidden 
  #     configure :recipient_user_id, :integer         # Hidden 
  #     configure :print_number, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CardPrintingComposition  ###

  # config.model 'CardPrintingComposition' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your card_printing_composition.rb model definition

  #   # Found associations:

  #     configure :card_printing, :belongs_to_association 
  #     configure :card_front_image, :belongs_to_association 
  #     configure :card_back_image, :belongs_to_association 

  #   # Found columns:

  #     configure :card_printing_composition_id, :integer 
  #     configure :card_printing_id, :integer         # Hidden 
  #     configure :card_front_image_id, :integer         # Hidden 
  #     configure :card_back_image_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 
  #     configure :latest, :boolean 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CardPrintingState  ###

  # config.model 'CardPrintingState' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your card_printing_state.rb model definition

  #   # Found associations:

  #     configure :card_printing, :belongs_to_association 

  #   # Found columns:

  #     configure :card_printing_state_id, :integer 
  #     configure :card_printing_id, :integer         # Hidden 
  #     configure :state, :string 
  #     configure :latest, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CardScan  ###

  # config.model 'CardScan' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your card_scan.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :card_scan_id, :integer 
  #     configure :card_printing_id, :integer 
  #     configure :app_id, :integer 
  #     configure :scanned_at, :datetime 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  CardScanAuthor  ###

  # config.model 'CardScanAuthor' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your card_scan_author.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :card_scan_author_id, :integer 
  #     configure :card_scan_id, :integer 
  #     configure :author_user_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  FacebookToken  ###

  # config.model 'FacebookToken' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your facebook_token.rb model definition

  #   # Found associations:

  #     configure :user, :belongs_to_association 
  #     configure :facebook_token_states, :has_many_association 

  #   # Found columns:

  #     configure :facebook_token_id, :integer 
  #     configure :user_id, :integer         # Hidden 
  #     configure :token, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  FacebookTokenState  ###

  # config.model 'FacebookTokenState' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your facebook_token_state.rb model definition

  #   # Found associations:

  #     configure :facebook_token, :belongs_to_association 

  #   # Found columns:

  #     configure :facebook_token_state_id, :integer 
  #     configure :facebook_token_id, :integer         # Hidden 
  #     configure :state, :string 
  #     configure :latest, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  RecipientAddress  ###

  # config.model 'RecipientAddress' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your recipient_address.rb model definition

  #   # Found associations:

  #     configure :recipient_user, :belongs_to_association 
  #     configure :address_api_response, :belongs_to_association 
  #     configure :address_request, :belongs_to_association 

  #   # Found columns:

  #     configure :recipient_address_id, :integer 
  #     configure :recipient_user_id, :integer         # Hidden 
  #     configure :address_api_response_id, :integer         # Hidden 
  #     configure :latest, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 
  #     configure :address_request_id, :integer         # Hidden 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  StripeCard  ###

  # config.model 'StripeCard' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your stripe_card.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :stripe_card_id, :integer 
  #     configure :exp_month, :integer 
  #     configure :exp_year, :integer 
  #     configure :fingerprint, :string 
  #     configure :last4, :string 
  #     configure :card_type, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  StripeCustomer  ###

  # config.model 'StripeCustomer' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your stripe_customer.rb model definition

  #   # Found associations:

  #     configure :user, :belongs_to_association 
  #     configure :stripe_customer_cards, :has_many_association 

  #   # Found columns:

  #     configure :stripe_customer_id, :integer 
  #     configure :user_id, :integer         # Hidden 
  #     configure :latest, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 
  #     configure :stripe_id, :string 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  StripeCustomerCard  ###

  # config.model 'StripeCustomerCard' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your stripe_customer_card.rb model definition

  #   # Found associations:

  #     configure :stripe_customer, :belongs_to_association 
  #     configure :stripe_card, :belongs_to_association 
  #     configure :stripe_customer_card_states, :has_many_association 

  #   # Found columns:

  #     configure :stripe_customer_card_id, :integer 
  #     configure :stripe_customer_id, :integer         # Hidden 
  #     configure :stripe_card_id, :integer         # Hidden 
  #     configure :latest, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  StripeCustomerCardState  ###

  # config.model 'StripeCustomerCardState' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your stripe_customer_card_state.rb model definition

  #   # Found associations:

  #     configure :stripe_customer_card, :belongs_to_association 

  #   # Found columns:

  #     configure :stripe_customer_card_state_id, :integer 
  #     configure :stripe_customer_card_id, :integer         # Hidden 
  #     configure :state, :string 
  #     configure :latest, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Transaction  ###

  # config.model 'Transaction' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your transaction.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :transaction_id, :integer 
  #     configure :card_order_id, :integer 
  #     configure :charged_customer_type, :string 
  #     configure :charged_customer_id, :integer 
  #     configure :response, :text 
  #     configure :status, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  TransactionLineItem  ###

  # config.model 'TransactionLineItem' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your transaction_line_item.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :transaction_line_item_id, :integer 
  #     configure :transaction_id, :integer 
  #     configure :description, :string 
  #     configure :price_units, :integer 
  #     configure :currency, :string 
  #     configure :is_credit, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  User  ###

  # config.model 'User' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your user.rb model definition

  #   # Found associations:

  #     configure :user_profiles, :has_many_association 
  #     configure :api_keys, :has_many_association 
  #     configure :facebook_tokens, :has_many_association 
  #     configure :stripe_customers, :has_many_association 
  #     configure :recipient_addresses, :has_many_association 
  #     configure :sent_address_requests, :has_many_association 
  #     configure :received_address_requests, :has_many_association 
  #     configure :card_orders, :has_many_association 
  #     configure :authored_card_designs, :has_many_association 
  #     configure :card_printings, :has_many_association 
  #     configure :authored_card_images, :has_many_association 

  #   # Found columns:

  #     configure :user_id, :integer 
  #     configure :facebook_id, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  UserLogin  ###

  # config.model 'UserLogin' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your user_login.rb model definition

  #   # Found associations:

  #     configure :user, :belongs_to_association 

  #   # Found columns:

  #     configure :user_login_id, :integer 
  #     configure :user_id, :integer         # Hidden 
  #     configure :app_id, :integer 
  #     configure :latest, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  UserProfile  ###

  # config.model 'UserProfile' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your user_profile.rb model definition

  #   # Found associations:

  #     configure :user, :belongs_to_association 

  #   # Found columns:

  #     configure :user_profile_id, :integer 
  #     configure :user_id, :integer         # Hidden 
  #     configure :name, :string 
  #     configure :first_name, :string 
  #     configure :last_name, :string 
  #     configure :location, :string 
  #     configure :middle_name, :string 
  #     configure :birthday, :datetime 
  #     configure :gender, :string 
  #     configure :email, :string 
  #     configure :latest, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :meta, :serialized 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end

end
