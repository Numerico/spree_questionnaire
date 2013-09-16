require 'spec_helper'

describe "questionnaire/finish.html.erb" do

  let(:user) { create :user }

  def finish_questionnaire
    questionnaire = create :questionnaire_with_questions
    visit spree.finish_questionnaire_path
  end

  # TODO require AutenticationHelpers from spree_auth_devise
  def sign_in
    visit '/login' unless current_path == spree.login_path
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'secret'
    click_button 'Login'
  end

  context "not logged in" do
    it "asks for login" do
      finish_questionnaire
      current_path.should eq spree.login_path
    end
    it "redirects back after asking" do
      finish_questionnaire
      sign_in
      current_path.should eq spree.finish_questionnaire_path
    end
  end

  context "logged in" do
    before :each do
      sign_in
      questionnaire = create :questionnaire_with_question_option_3
      visit spree.questionnaire_path
      click_link 'Start'
    end

    it "shows result" do
      #populate answers
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => '1'
      click_button 'Update Question'# 1
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => '1'
      click_button 'Update Question'# 2
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => '1'
      click_button 'Update Question'# 3
      #
      expect(user.reload.questionnaire_result).to eq "true"
      page.should have_selector '#questionnaire-result-wrapper'
      find('#questionnaire-result-wrapper #questionnaire-result').should have_content user.questionnaire_result
    end

    it "asks mail if error" do
      # populate answers
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => '3'
      click_button 'Update Question'# 1
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => '3'
      click_button 'Update Question'# 2
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => '3'
      click_button 'Update Question'# 3
      # tests
      page.should have_selector '#questionnaire-result-wrapper #questionnaire-form form'
      page.should have_selector '#questionnaire-result-wrapper #questionnaire-form form input[type="submit"]'
    end

  end

end