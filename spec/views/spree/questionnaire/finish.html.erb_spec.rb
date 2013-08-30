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
    
  end

end