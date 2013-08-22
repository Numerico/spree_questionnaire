Spree::Core::Engine.routes.draw do

  resource :questionnaire, :only => [:show] do
    resources :questions, :only => [] do
      resources :question_options, :only => [:update]
    end
  end

end
