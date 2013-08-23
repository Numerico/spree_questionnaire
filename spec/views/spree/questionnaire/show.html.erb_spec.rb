require 'spec_helper'

describe "questionnaire/show.html.erb" do

    it "displays an introduction" do
      create :questionnaire
      visit spree.questionnaire_path
      within "#wrapper" do
        page.should have_selector 'p'
      end
    end

end
