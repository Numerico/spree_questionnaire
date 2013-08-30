require 'spec_helper'

describe Spree::QuestionnairesController do

  routes { Spree::Core::Engine.routes }

  describe "GET 'show'" do
    it "returns http success" do
      create :questionnaire
      get :show
      response.should be_success
    end
  end

  describe "GET 'finish'" do
    let(:user) { create :user }
    context "logged in" do
      before :each do
        sign_in user
      end
      it "doesn't ask for login" do
        get :finish
        response.should be_success
      end
      it "associates answers in session" do
        questionnaire = create :questionnaire_with_question_option
        answers = {}
        questionnaire.questions.each do |question|
           question.question_options.each do  |option|
             answers.store option.id, 'some input'
           end
        end
        get :finish, nil, session.to_hash.merge!({ :questionnaire_answers => answers })
        expect(user.question_option_answers).to_not be_empty
        user.question_option_answers.each do |user_answer|
          expect(user_answer.answer).to eq 'some input'
        end
      end
    end
    context "not logged in" do
      it "asks for login" do
        get :finish
        response.should redirect_to(spree.login_path)
      end
      it "stores path to return after login" do
        get :finish
        expect(session["spree_user_return_to"]).to_not be_nil
      end
    end
  end

end
