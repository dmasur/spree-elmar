Rails.application.routes.draw do
  namespace :admin do
    resource :elmar do
      member do
        get :create_shop_xml
      end
    end
  end
end
