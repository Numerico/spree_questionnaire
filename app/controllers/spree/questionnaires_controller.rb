class Spree::QuestionnairesController < Spree::StoreController

  before_filter :check_authorization, only: [:finish]

  def show
    @questionnaire = Questionnaire.get_questionnaire
    @question_one = @questionnaire.ordered_questions.first unless @questionnaire.nil?
  end

  def finish
    associate_user_answers if session[:questionnaire_answers]
    # generat result
    @parsed = parse_answers(spree_current_user.question_option_answers)
    unless @parsed.empty?
      result = QuestionnaireResult.instance.resolve @parsed
      spree_current_user.questionnaire_result = result.to_s
      spree_current_user.save!
    end
  end

  # override
  def unauthorized
    session["spree_user_return_to"] = request.fullpath
    redirect_to spree.login_path
  end

  protected

  def check_authorization
    authorize! :finish, Questionnaire
  end

  def associate_user_answers
    session[:questionnaire_answers].each do |k, v|
      QuestionOptionAnswer.find_or_create_by_question_option_id question_option_id: k, answer: v, user_id: spree_current_user.id
    end
  end

  def parse_answers(answers)
    parsed = []
    QuestionnaireResult.instance.tree_attributes.each do |attr|
      answer = answers.includes(:question_option).where("question_options.code = '#{attr}'").first
      parsed << answer.answer if answer
    end
    parsed
  end

end
