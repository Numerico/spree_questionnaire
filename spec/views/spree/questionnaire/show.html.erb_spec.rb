require 'spec_helper'

describe "questionnaire/show.html.erb" do

  it "displays an introduction" do
    create :questionnaire
    visit spree.questionnaire_path
    within "#wrapper" do
      page.should have_selector 'p'
    end
  end

  it "has a link to the first question" do
    questionnaire = create :questionnaire_with_questions
    question_one = questionnaire.ordered_questions.first
    visit spree.questionnaire_path
    within "#wrapper" do
      page.should have_selector "a[href='"+spree.questionnaire_question_path(question_one)+"']"
    end
  end

end
