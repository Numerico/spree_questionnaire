require 'spec_helper'

describe Spree::QuestionsController do

  routes { Spree::Core::Engine.routes }

  describe "GET 'show'" do
    it "returns http success" do
      question = create :question_with_option
      visit spree.questionnaire_question_path question
      response.should be_success
    end
  end

  describe "PUT 'update'" do

    render_views # TODO rewrite as functional tests

    let(:user) { create :user }

    def answer_a_question(which)
      questionnaire = create :questionnaire_with_question_option
      question = questionnaire.ordered_questions.send(which)
      option = question.question_options.first
      put_answer question, option, "input entered"
      {:question => question, :option => option}
    end

    def put_answer(question, option, answer)
      put :update, "id" => question.id,
        "question"=>{
          "question_options_attributes" => {
            "0" => {
              "id" => option.id,
              "question_option_answers_attributes" => {
                "0" => { "answer" => answer }
              }
            }
          }
        }
    end

    it "redirects to next question" do
      questionnaire = create :questionnaire_with_questions
      question = questionnaire.ordered_questions.first
      visit spree.questionnaire_question_path question
      click_button 'Update Question'
      current_path.should eq(spree.questionnaire_question_path(question.next))
    end

    it "stores the answer" do
      questionnaire = create :questionnaire_with_question_option
      question = questionnaire.ordered_questions.first
      option = question.question_options.first
      visit spree.questionnaire_question_path question
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => 'input entered'
      click_button 'Update Question'
      answer = option.question_option_answers.first
      expect(answer.answer).to eq('input entered')
    end

    it "can store multiple answers" do
      questionnaire = create :questionnaire_with_multiple_options
      question = questionnaire.ordered_questions.first
      visit spree.questionnaire_question_path question
      question.question_options.each_with_index do |option, index|
        fill_in 'question[question_options_attributes]['+index.to_s+'][question_option_answers_attributes][0][answer]', :with => 'input entered'
      end
      click_button 'Update Question'
      question.question_options.reload.each do |option|
        answer = option.question_option_answers.first
        expect(answer.answer).to eq('input entered')
      end
    end

    it "can store multiple hash answers" do
      questionnaire = create :questionnaire_with_multiple_hashs
      question = questionnaire.ordered_questions.first
      visit spree.questionnaire_question_path question
      question.question_options.each_with_index do |option, index|
        select 'two', :from => 'question[question_options_attributes]['+index.to_s+'][question_option_answers_attributes][0][answer]'
      end
      click_button 'Update Question'
      question.question_options.each do |option|
        answer = option.question_option_answers.first
        expect(answer.answer).to eq("2")
      end
    end

    it "does not override answers" do
      questionnaire = create :questionnaire_with_question_option
      question = questionnaire.ordered_questions.first
      option = question.question_options.first
      # one user
      visit spree.questionnaire_question_path question
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => 'input entered'
      click_button 'Update Question'
      # other user
      visit spree.questionnaire_question_path question
      fill_in 'question[question_options_attributes][0][question_option_answers_attributes][0][answer]', :with => 'other input entered'
      click_button 'Update Question'
      # both were stored
      expect(option.question_option_answers.count).to be 2
      expect(option.question_option_answers.select{|qoa| qoa.answer == 'input entered'}.count).to be 1
      expect(option.question_option_answers.select{|qoa| qoa.answer == 'other input entered'}.count).to be 1
    end

    # because of some bug
    it "allows not to select radio buttons" do
      lambda {
        question = create :question_with_radio_button
        visit spree.questionnaire_question_path question
        click_button 'Update Question'
      }.should_not raise_error
    end

    it "redirects when finished" do
      answer_a_question :last
      response.should redirect_to(spree.finish_questionnaire_path)
    end

    it "parses data for test" do
      answer_a_question :last
      expect(assigns[:parsed]).to_not be_empty
    end

    it "result data follows answers order" do
      questionnaire = create :questionnaire_with_question_option
      @answers = {}
      qo2 = questionnaire.question_options.where(code: 'two').first
      qo1 = questionnaire.question_options.where(code: 'one').first
      # TODO stored second first so order will have to be switched (NOT VALID NOW, NEEDS 3)
      #@answers.store qo2.id, 2
      @answers.store qo1.id.to_s, "1"
      put :update, {
        "id" => qo2.question.id,
        "question"=>{
          "question_options_attributes" => {
            "0" => {
              "id" => qo2.id,
              "question_option_answers_attributes" => {
                "0" => { "answer" => 2 }
              }
            }
          }
        }
      },# request
      { :questionnaire_answers => @answers }# session
      expect(assigns[:parsed]).to eq ["1", "2"]
      expect(assigns[:result]).to eq true
    end

    it "validates" do
      questionnaire = create :questionnaire_with_question_option_required
      question = questionnaire.ordered_questions.first
      option = question.question_options.first
      put_answer question, option, "" # empty
      response.should be_success
    end

    it "doesn't validate if not required" do
      questionnaire = create :questionnaire_with_question_option
      question = questionnaire.ordered_questions.first
      option = question.question_options.first
      put_answer question, option, "" # empty
      response.should be_redirect
    end

    context "if logged in" do
      before do
        sign_in user
      end
      it "associates answers to current user" do
        helper = answer_a_question :first
        answer = helper[:option].question_option_answers.first
        expect(answer.user).to eq(user)
      end
    end

    context "not logged in" do

      it "stores the answers in session" do
        helper = answer_a_question :first
        expect(session[:questionnaire_answers]).to_not be_nil
        expect(session[:questionnaire_answers]).to_not be_empty
        answer = helper[:option].question_option_answers.first
        expect(session[:questionnaire_answers]).to have_key(answer.id.to_s)
      end

    end
  end

end
