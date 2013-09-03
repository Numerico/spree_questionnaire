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
    
    before :all do# TODO NOT ALL..
      QuestionnaireResult.load_data ['one', 'two'], [["1", "1", true], ["1", "2", false], ["2", "1", false], ["2", "2", true]]
    end

    context "logged in" do
      before :each do
        sign_in user
      end
      it "doesn't ask for login" do
        get :finish
        response.should be_success
      end
      context "with answers" do
        # is logged in with session values because he's comming back from login/redirect
        before :each do
          questionnaire = create :questionnaire_with_question_option
          @answers = {}
          questionnaire.questions.each do |question|
             question.question_options.each do  |option|
               @answers.store option.id, 1
             end
          end
        end
        it "associates answers in session" do
          get :finish, nil, session.to_hash.merge!({ :questionnaire_answers => @answers })
          expect(user.question_option_answers).to_not be_empty
          user.question_option_answers.each do |user_answer|
            expect(user_answer.answer).to eq "1"
          end
        end
        it "generates the result" do
          get :finish, nil, session.to_hash.merge!({ :questionnaire_answers => @answers })
          expect(user.reload.questionnaire_result).to eq "true"
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
