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

  describe "GET 'finish'" do
    let(:user) { create :user }
    context "logged in" do
      before do
        sign_in user
      end
      it "doesn't ask for login" do
        get :finish
        response.should be_success
      end
    end
    context "not logged in" do
      it "asks for login" do
        get :finish
        response.should redirect_to(spree.login_path)
      end
    end
  end

end
