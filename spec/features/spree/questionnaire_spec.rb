require 'spec_helper'

describe "::integration tests::" do

  let(:user){ create :user }

  def log_in
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'secret'
    click_button 'Login'
  end

  it "navigates through and back " do
    questionnaire = create :questionnaire
    q1 = create :question_with_int, questionnaire_id: questionnaire.id, position: 1
    q2 = create :question_with_array, questionnaire_id: questionnaire.id, position: 2
    q3 = create :question_with_hash, questionnaire_id: questionnaire.id, position: 3
    q4 = create :question_with_radio_button, questionnaire_id: questionnaire.id, position: 4
    visit spree.questionnaire_path
    current_path.should eq spree.questionnaire_path
    click_link 'Start'
    current_path.should eq spree.questionnaire_question_path q1
    fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => 'input entered'
    click_button 'Update Question'
    current_path.should eq spree.questionnaire_question_path q2
    select '2', :from => 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]'
    click_button 'Update Question'
    current_path.should eq spree.questionnaire_question_path q3
    select 'two', :from => 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]'
    click_button 'Update Question'
    current_path.should eq spree.questionnaire_question_path q4
    choose 2
    click_button 'Update Question'
    current_path.should eq spree.login_path
    log_in
    current_path.should eq spree.finish_questionnaire_path
  end

  context "common inputs" do

    before :each do
      questionnaire = create :questionnaire
      create :question_with_int, questionnaire_id: questionnaire.id, position: 1
      create :question_with_array, questionnaire_id: questionnaire.id, position: 2
      create :question_with_hash, questionnaire_id: questionnaire.id, position: 3
      create :question_with_radio_button, questionnaire_id: questionnaire.id, position: 4
    end

    it "associates answers to user after login" do
      visit spree.questionnaire_path
      click_link 'Start'
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => 'input entered'
      click_button 'Update Question'#1
      select '2', :from => 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]'
      click_button 'Update Question'#2
      select 'two', :from => 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]'
      click_button 'Update Question'#3
      choose 2
      click_button 'Update Question'#4
      log_in
      current_path.should eq spree.finish_questionnaire_path
      expect(user.reload.question_option_answers).to_not be_empty
    end
  
    it "associates user at each question when logged in" do
      visit spree.login_path
      log_in
      visit spree.questionnaire_path
      click_link 'Start'
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => 'input entered'
      click_button 'Update Question'#1
      expect(QuestionOptionAnswer.where(user_id: user.id).count).to eq 1
      select '2', :from => 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]'
      click_button 'Update Question'#2
      expect(QuestionOptionAnswer.where(user_id: user.id).count).to eq 2
      select 'two', :from => 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]'
      click_button 'Update Question'#3
      expect(QuestionOptionAnswer.where(user_id: user.id).count).to eq 3
      choose 2
      click_button 'Update Question'#4
      expect(QuestionOptionAnswer.where(user_id: user.id).count).to eq 4
      current_path.should eq spree.finish_questionnaire_path
      expect(QuestionOptionAnswer.where(user_id: user.id).count).to eq 4 
    end

  end

  context "valid results" do

    before :each do
      questionnaire = create :questionnaire
      create :question_with_int, questionnaire_id: questionnaire.id, position: 1
      create :question_with_int, questionnaire_id: questionnaire.id, position: 2
    end

    it "updates answers for user when he repeats them" do
      visit spree.login_path
      log_in
      # first time
      visit spree.questionnaire_path
      click_link 'Start'
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => '1'
      click_button 'Update Question'#1
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => '1'
      click_button 'Update Question'#2
      expect(user.reload.questionnaire_result).to eq "true"
      # second time
      visit spree.questionnaire_path
      click_link 'Start'
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => '2'
      click_button 'Update Question'#1
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => '1'
      click_button 'Update Question'#2
      # saved without replacing
      expect(QuestionOptionAnswer.where(user_id: user.id).count).to eq 4
      # using latest
      expect(user.reload.questionnaire_result).to eq "false"
    end

    it "doesn't ask for login on error result" do
      visit spree.questionnaire_path
      click_link 'Start'
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => '3'
      click_button 'Update Question'
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => '3'
      click_button 'Update Question'
      current_path.should eq spree.finish_questionnaire_path
      find('#questionnaire-result').should have_content 'ERROR'
    end

  end

end