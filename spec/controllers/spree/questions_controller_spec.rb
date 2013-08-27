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
    let(:user) { create :user }

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
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => 'input entered'
      click_button 'Update Question'
      answer = option.question_option_answers.first
      expect(answer.answer).to eq('input entered')
    end

    it "can store multiple answers" do
      questionnaire = create :questionnaire_with_multiple_options
      question = questionnaire.ordered_questions.first
      visit spree.questionnaire_question_path question
      question.question_options.each_with_index do |option, index|
        fill_in 'question[question_options_attributes]['+index.to_s+'][question_option_answers_attributes][0][answer]', :with => 'input entered'
      end
      click_button 'Update Question'
      question.question_options.reload.each do |option|
        answer = option.question_option_answers.first
        expect(answer.answer).to eq('input entered')
      end
    end

    it "can store multiple hash answers" do
      questionnaire = create :questionnaire_with_multiple_hashs
      question = questionnaire.ordered_questions.first
      visit spree.questionnaire_question_path question
      question.question_options.each_with_index do |option, index|
        select 'two', :from => 'question[question_options_attributes]['+index.to_s+'][question_option_answers_attributes][0][answer]'
      end
      click_button 'Update Question'
      question.question_options.each do |option|
        answer = option.question_option_answers.first
        expect(answer.answer).to eq("2")
      end
    end

    it "does not override answers" do
      questionnaire = create :questionnaire_with_question_option
      question = questionnaire.ordered_questions.first
      option = question.question_options.first
      # one user
      visit spree.questionnaire_question_path question
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => 'input entered'
      click_button 'Update Question'
      # other user
      visit spree.questionnaire_question_path question
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => 'other input entered'
      click_button 'Update Question'
      # both were stored
      expect(option.question_option_answers.count).to be 2
      expect(option.question_option_answers.select{|qoa| qoa.answer == 'input entered'}.count).to be 1
      expect(option.question_option_answers.select{|qoa| qoa.answer == 'other input entered'}.count).to be 1
    end

    context "if logged in" do
      before do
         visit '/login'
         fill_in 'Email', :with => user.email
         fill_in 'Password', :with => 'secret'
         click_button 'Login'
         #TODO require AutenticationHelpers from spree_auth_devise
      end
      it "associates answers to current user" do
        questionnaire = create :questionnaire_with_question_option
        question = questionnaire.ordered_questions.first
        option = question.question_options.first
        visit spree.questionnaire_question_path question
        fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => 'input entered'
        click_button 'Update Question'
        answer = option.question_option_answers.first
        expect(answer.user).to eq(user)
      end
    end

  end

end
