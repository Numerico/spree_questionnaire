require 'spec_helper'

describe Spree::QuestionnairesController do

  routes { Spree::Core::Engine.routes }

  describe "GET 'show'" do
    it "returns http success" do
      create :questionnaire
      get :show
      response.should be_success
    end
  end

end
