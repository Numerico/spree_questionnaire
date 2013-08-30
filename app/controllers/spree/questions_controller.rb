class Spree::QuestionsController < Spree::StoreController

  def show
    @question = Question.get_question params[:id]
    @next = @question.next
    @previous = @question.previous
    @question.question_options.each {|option| option.question_option_answers.build }
  end

  def update
    @question = Question.get_question params[:id]
    if @question.update_attributes massage_params(params)
      if @question.next
        redirect_to spree.questionnaire_question_path @question.next
      else
        redirect_to spree.finish_questionnaire_path
      end
    else
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

end
