Spree::Core::Engine.routes.draw do

  resource :questionnaire, :only => [:show] do
    resources :questions, :only => [:show, :update]
    get 'finish'
    post 'notify'
  end

end
