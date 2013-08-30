class Spree::QuestionnairesController < Spree::StoreController

  before_filter :check_authorization, only: [:finish]

  def show
    @questionnaire = Questionnaire.get_questionnaire
    @question_one = @questionnaire.ordered_questions.first unless @questionnaire.nil?
  end

  def finish
    
  end

  # override
  def unauthorized
    redirect_to spree.login_path
  end

  protected

  def check_authorization
    authorize! :finish, Questionnaire
  end

end
