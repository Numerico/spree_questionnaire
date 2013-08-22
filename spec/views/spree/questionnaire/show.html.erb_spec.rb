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
save_and_open_page
    page.should have_selector 'form number'
  end

end
