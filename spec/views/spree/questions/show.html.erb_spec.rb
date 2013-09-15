require 'spec_helper'

describe "questions/show.html.erb" do

  context "functionality" do

    def no_labels
      page.should_not have_selector 'label'
    end

    it "uses simple form" do
      question = create :question_with_option
      visit spree.questionnaire_question_path question
      page.should have_selector('form textarea')
      no_labels
    end
  
    it "can display number inputs" do
      question = create :question_with_int
      visit spree.questionnaire_question_path question
      page.should have_selector 'form input[type="number"]'
      no_labels
    end
  
    it "can display array inputs" do
      question = create :question_with_array
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector 'form select'
      end
      no_labels
    end
  
    it "can display hash inputs" do
      question = create :question_with_hash
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector 'select option[value="2"]'
        find('option[value="2"]').should have_content("two")
      end
      no_labels
    end

    it "can set prompt for selects" do
      question = create :question_with_hash_prompt
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector 'select option[value=""]'
        find('option[value=""]').should have_content("hey there")
      end
      no_labels
    end

    it "can display multiple inputs" do
      question = create :questions_with_option
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector('form textarea', count: 2)
      end
      no_labels
    end
  
    it "can display multiple hashs" do
      question = create :questions_with_hash
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector('form select', count: 2)
      end
      no_labels
    end

    it "can display radio buttons" do
      question = create :question_with_radio_button
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector('form input[type="radio"]', count: 3)
      end
      page.should have_selector 'label' # radio buttons do need labels
    end

    it "can display range selects" do
      question = create :question_with_range
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector 'form input[type="range"]'
        question_option = question.question_options.first
        find('input[type="range"]')['step'].should eq "1" # assumes step 1 TODO
        find('input[type="range"]')['min'].should eq question_option.value.keys.first # min is first key
        find('input[type="range"]')['max'].should eq question_option.value.keys.last # max is last key
      end
      no_labels
    end

    it "renders a disabled select with range for unsupporting browsers" do
      question = create :question_with_range
      visit spree.questionnaire_question_path question
      question_option = question.question_options.first
      within "#wrapper" do
        page.should have_selector 'select[disabled="disabled"]'
        question_option.value.each do |k, v|
          page.should have_selector "select option[value='#{k}']"
          find("select option[value='#{k}']").should have_content v
        end
      end
    end

  end

  context "view" do

    it "displays a text" do
      question = create :question_with_option
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector '.question-form h1'
        find('.question-form h1').text.length.should be > 1
      end
    end

    it "uses the right form" do
      questionnaire = create :questionnaire_with_questions
      question = questionnaire.questions[2]
      visit spree.questionnaire_question_path question
      page.should have_selector 'form[action="'+spree.questionnaire_question_path(question)+'"]'
    end

    it "has back links" do
      questionnaire = create :questionnaire_with_questions
      question = questionnaire.questions[2]
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector 'div.question-form-before a[href="'+spree.questionnaire_question_path(question.previous)+'"]'
      end
    end

    it "uses a submit as forth link" do
      questionnaire = create :questionnaire_with_questions
      question = questionnaire.questions[2]
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector 'div.question-form-after input[type="submit"]'
      end
    end

    it "links back to questionnaire if is first" do
      questionnaire = create :questionnaire_with_questions
      question = questionnaire.questions.first
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector 'div.question-form-before a[href="'+spree.questionnaire_path+'"]'
      end
    end

    it "shows validation errors" do
      questionnaire = create :questionnaire_with_question_option_required
      question = questionnaire.questions.first
      visit spree.questionnaire_question_path question
      click_button 'Update Question'
      within "#wrapper" do
        page.should have_selector '.flash.error'
      end
    end

    it "has back link when validated" do
      questionnaire = create :questionnaire_with_question_option_required
      question = questionnaire.questions[1]
      visit spree.questionnaire_question_path question
      click_button 'Update Question'
      within "#wrapper" do
        page.should have_selector '.flash.error'
        page.should have_selector 'div.question-form-before a[href="'+spree.questionnaire_question_path(question.previous)+'"]'
      end
    end

    it "uses default value for radio buttons" do
      question = create :question_with_radio_button_required
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector 'input[type="radio"][checked="checked"]'
      end
    end

  end

end
