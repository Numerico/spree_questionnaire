require 'spec_helper'

describe Spree::QuestionsController do

  describe "GET 'show'" do
    it "returns http success" do
      question = create :question_with_option
      visit spree.questionnaire_question_path question
      response.should be_success
    end
  end

end
