require 'spec_helper'

describe Spree::QuestionnaireController do

  describe "GET 'show'" do
    it "returns http success" do
      visit spree.questionnaire_path
      response.should be_success
    end
  end

end
