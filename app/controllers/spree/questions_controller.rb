class Spree::QuestionsController < Spree::StoreController

  before_filter :question_and_siblings

  def show
    @question.question_options.each {|option| option.question_option_answers.build }
    @ordered_options = @question.question_options.order("position ASC")
  end

  def update
    if @question.update_attributes massage_params(params)
      if @next
        redirect_to spree.questionnaire_question_path @next
      else
        generate_result
        redirect_to spree.finish_questionnaire_path
      end
    else
      flash[:error] = Spree.t('questionnaire.required_msg')
      render :show
    end
  end

  protected

  def question_and_siblings
    @question = Question.get_question params[:id]
    @next = @question.next
    @previous = @question.previous
  end

  def massage_params(params)
    return unless params[:question]
    params[:question][:question_options_attributes].each do |k,question_option|
      next unless question_option[:question_option_answers_attributes]
      question_option[:question_option_answers_attributes].each do |q, answer|
        # extract data for session
        session[:questionnaire_answers] = {} if session[:questionnaire_answers].nil?
        session[:questionnaire_answers].store question_option[:id], answer[:answer]
        if spree_current_user # associate it at each step
          params[:question][:question_options_attributes][k][:question_option_answers_attributes][q] = answer.merge({:user_id => spree_current_user.id})
        end
      end
    end
    params[:question]
  end

  def generate_result
    if session[:questionnaire_answers]
      qresult = QuestionnaireResult.new
      @parsed = parse_answers session[:questionnaire_answers], qresult
      @result = qresult.resolve @parsed unless @parsed.empty?
      session[:result] = @result.to_s
    end
  end

  def parse_answers answers, result
    result.tree_attributes.collect do |attr|
      question_option = QuestionOption.where(code: attr).first
      next unless question_option && answers.has_key?(question_option.id.to_s)
      answers[question_option.id.to_s]
    end
  end

end
