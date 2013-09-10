class Spree::QuestionsController < Spree::StoreController

  before_filter :question_and_siblings

  def show
    @question.question_options.each {|option| option.question_option_answers.build }
  end

  def update
    if @question.update_attributes massage_params(params)
      if @next
        redirect_to spree.questionnaire_question_path @next
      else
        redirect_to spree.finish_questionnaire_path
      end
    else
      flash[:error] = Spree.t('questionnaire.required_msg')
      render :show
    end
  end

  protected

  def massage_params(params)
    return unless params[:question]
    params[:question][:question_options_attributes].each do |k,question_option|
      next unless question_option[:question_option_answers_attributes]
      question_option[:question_option_answers_attributes].each do |q, answer|
        if spree_current_user
          params[:question][:question_options_attributes][k][:question_option_answers_attributes][q] = answer.merge({:user_id => spree_current_user.id})
        else
          session[:questionnaire_answers] = {} if session[:questionnaire_answers].nil?
          session[:questionnaire_answers].store question_option[:id], answer[:answer]
        end
      end
    end
    params[:question]
  end

  def question_and_siblings
    @question = Question.get_question params[:id]
    @next = @question.next
    @previous = @question.previous
  end

end
