require 'spec_helper'

describe Spree::QuestionsController do

  describe "GET 'show'" do
    it "returns http success" do
      question = create :question_with_option
      visit spree.questionnaire_question_path question
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    render_views

    it "redirects to next question" do
      questionnaire = create :questionnaire_with_questions
      question = questionnaire.ordered_questions.first
      visit spree.questionnaire_question_path question
      click_button 'Update Question'
      current_path.should eq(spree.questionnaire_question_path(question.next))
    end

    it "stores the answer" do
      questionnaire = create :questionnaire_with_question_option
      question = questionnaire.ordered_questions.first
      option = question.question_options.first
      visit spree.questionnaire_question_path question
      fill_in 'question[question_options_attributes][0][answer]', :with => 'input entered'
      click_button 'Update Question'
      expect(option.reload.answer).to eq('input entered')
    end

  end

end
