require 'spec_helper'

describe "questionnaire/show.html.erb" do

  it "uses simple form" do
    question = create :question_with_option
    visit spree.questionnaire_path
    page.should have_selector('form textarea')
  end

  it "can display number inputs" do
    question = create :question_with_int
    visit spree.questionnaire_path
    page.should have_selector 'form input[type="number"]'
  end

  it "can display array inputs" do
    question = create :question_with_array
    visit spree.questionnaire_path
    within "#wrapper" do
      page.should have_selector 'form select'
    end
  end

  it "can display hash inputs" do
    question = create :question_with_hash
    visit spree.questionnaire_path
    within "#wrapper" do
      page.should have_selector 'select option[value="2"]'
      find('option[value="2"]').should have_content("two")
    end
  end

end
