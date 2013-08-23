require 'spec_helper'

describe "questions/show.html.erb" do

  context "functionality" do

    it "uses simple form" do
      question = create :question_with_option
      visit spree.questionnaire_question_path question
      page.should have_selector('form textarea')
    end
  
    it "can display number inputs" do
      question = create :question_with_int
      visit spree.questionnaire_question_path question
      page.should have_selector 'form input[type="number"]'
    end
  
    it "can display array inputs" do
      question = create :question_with_array
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector 'form select'
      end
    end
  
    it "can display hash inputs" do
      question = create :question_with_hash
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector 'select option[value="2"]'
        find('option[value="2"]').should have_content("two")
      end
    end
  
    it "can display multiple inputs" do
      question = create :questions_with_option
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector('form textarea', count: 2)
      end
    end
  
    it "can display multiple hashs" do
      question = create :questions_with_hash
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector('form select', count: 2)
      end
    end

  end

  context "view" do

    it "displays a text" do
      question = create :question_with_option
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector 'div.question-text p'
        find('div.question-text p').text.length.should be > 1
      end
    end

    it "uses the right question" do
      questionnaire = create :questionnaire_with_questions
      question = questionnaire.questions[2]
      visit spree.questionnaire_question_path question
      page.should have_selector 'form[action="'+spree.questionnaire_question_path(question)+'"]'
    end

    it "has back and forth links" do
      questionnaire = create :questionnaire_with_questions
      question = questionnaire.questions[2]
      visit spree.questionnaire_question_path question
      within "#wrapper" do
        page.should have_selector 'div.question-form-before a[href="'+spree.questionnaire_question_path(question.previous)+'"]'
        page.should have_selector 'div.question-form-after a[href="'+spree.questionnaire_question_path(question.next)+'"]'
      end
    end

  end

end
