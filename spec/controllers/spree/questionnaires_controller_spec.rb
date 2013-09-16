require 'spec_helper'

describe Spree::QuestionnairesController do

  routes { Spree::Core::Engine.routes }

  describe "GET 'show'" do
    it "returns http success" do
      create :questionnaire
      get :show
      response.should be_success
    end
    it "redirects to first question if no introduction" do
      create :questionnaire_no_intro
      get :show
      response.should be_redirect
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
          get :finish, nil, session.to_hash.merge!({ :questionnaire_answers => @answers, :result => "true" })
        end
        it "associates answers in session" do
          expect(user.question_option_answers).to_not be_empty
          user.question_option_answers.each do |user_answer|
            expect(user_answer.answer).to eq "1"
          end
        end
        it "associates the result" do
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

  describe "POST 'notify'" do
    it "redirects with a message" do
      post :notify, { # request
        'questionnaire_notify' => {
          'email' => 'webmaster@numerica.cl'
        }
      }
      response.should redirect_to root_path
      flash[:notice].should_not be_empty
    end
    it "stores email with answers" do
      questionnaire = create :questionnaire_with_question_option
      @answers = {}
      questionnaire.questions.each do |question|
         question.question_options.each do  |option|
           answer = "1"
           QuestionOptionAnswer.create question_option_id: option.id, answer: answer # created by questions_controller#update
           @answers.store option.id.to_s, answer
         end
      end
      post :notify, { # request
        'questionnaire_notify' => {
          'email' => 'webmaster@numerica.cl'
        }
      } , { # session
        'questionnaire_answers' => @answers,
        'result' => "true"
      }
      notify = QuestionnaireNotify.first
      notify.should_not be_nil
      notify.question_option_answers.should_not be_empty
    end
    it "validates email presence" do
      questionnaire = create :questionnaire_with_question_option
      @answers = {}
      post :notify, { # request
        'questionnaire_notify' => {
          'email' => ''
        }
      }
      response.should be_success
      flash[:error].should_not be_nil
    end
    it "validates email formar" do
      questionnaire = create :questionnaire_with_question_option
      @answers = {}
      post :notify, { # request
        'questionnaire_notify' => {
          'email' => 'notanemail'
        }
      }
      response.should be_success
      flash[:error].should_not be_nil
    end
  end
end
