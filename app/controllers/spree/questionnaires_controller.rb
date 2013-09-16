class Spree::QuestionnairesController < Spree::StoreController

  before_filter :check_authorization, only: [:finish]

  def show
    @questionnaire = Questionnaire.get_questionnaire
    @question_one = @questionnaire.ordered_questions.first unless @questionnaire.nil?
    redirect_to questionnaire_question_path @question_one unless @questionnaire.introduction
  end

  def finish
    if session[:result] != "ERROR"
      associate_user_answers if session[:questionnaire_answers]
      spree_current_user.update_attributes(:questionnaire_result => session[:result]) unless session[:result].nil?
    else
      @notify = QuestionnaireNotify.new
    end
  end

  def notify
    notify = QuestionnaireNotify.create params[:notify]
    if notify
      if session[:questionnaire_answers]
        notify.question_option_answers = get_answers
        notify.save
      end
      flash[:notice] = Spree.t 'questionnaire.notified'
      redirect_to root_path
    else
      render :finish
    end
  end

  # override
  def unauthorized
    session["spree_user_return_to"] = request.fullpath
    redirect_to spree.login_path
  end

  protected

  def check_authorization
    authorize! :finish, Questionnaire unless session[:result] == "ERROR"
  end

  def associate_user_answers
    session[:questionnaire_answers].each do |k, v|
      answer = QuestionOptionAnswer.find_or_create_by_question_option_id question_option_id: k, answer: v, user_id: spree_current_user.id
      answer.update_attributes(:user_id => spree_current_user.id) if answer.user_id.nil? # TODO ugly
    end
  end

  def get_answers
    session[:questionnaire_answers].collect do |k, v|
      QuestionOptionAnswer.where(question_option_id: k, answer: v, user_id: nil).first # TODO what if there are duplicates?
    end
  end

end