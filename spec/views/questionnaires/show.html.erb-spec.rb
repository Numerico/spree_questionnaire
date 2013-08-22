require 'spec_helper'

describe "questionnaire/show.html.erb" do

  it "uses simple form" do
    question = create :question_with_options
    visit spree.questionnaire_path
    page.should have_selector('form textarea')
  end

end
