Spree::Core::Engine.routes.draw do

  resource :questionnaire, :only => [:show] do
    resources :questions, :only => [:update] do
      resources :question_options, :only => []
    end
  end

end
