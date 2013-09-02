require 'spec_helper'

describe "integration" do
  it "basic navigation " do
    questionnaire = create :questionnaire
    q1 = create :question_with_int, questionnaire_id: questionnaire.id, position: 1
    q2 = create :question_with_array, questionnaire_id: questionnaire.id, position: 2
    q3 = create :question_with_hash, questionnaire_id: questionnaire.id, position: 3
    q4 = create :question_with_radio_button, questionnaire_id: questionnaire.id, position: 4
    #navigation
    visit spree.questionnaire_path
    current_path.should eq spree.questionnaire_path
    click_link 'Start'
    current_path.should eq spree.questionnaire_question_path q1
    click_button 'Update Question'
    current_path.should eq spree.questionnaire_question_path q2
    click_button 'Update Question'
    current_path.should eq spree.questionnaire_question_path q3
    click_button 'Update Question'
    current_path.should eq spree.questionnaire_question_path q4
    click_button 'Update Question'
    current_path.should eq spree.login_path
    # TODO DRY login
    user = create :user
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'secret'
    click_button 'Login'
    #
    current_path.should eq spree.finish_questionnaire_path
  end
  it "database" do
    questionnaire = create :questionnaire
    q1 = create :question_with_int, questionnaire_id: questionnaire.id, position: 1
    q2 = create :question_with_array, questionnaire_id: questionnaire.id, position: 2
    q3 = create :question_with_hash, questionnaire_id: questionnaire.id, position: 3
    q4 = create :question_with_radio_button, questionnaire_id: questionnaire.id, position: 4
    #navigation
    visit spree.questionnaire_question_path q1
    fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => 'input entered'
    click_button 'Update Question'#1
    select '2', :from => 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]'
    click_button 'Update Question'#2
    select 'two', :from => 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]'
    click_button 'Update Question'#3
    choose 2
    click_button 'Update Question'#4
    # TODO DRY login
    user = create :user
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'secret'
    click_button 'Login'
    #
    current_path.should eq spree.finish_questionnaire_path
    # expect(user.question_option_answers).to_not be_empty TODO
  end
end
