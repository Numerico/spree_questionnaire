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
      redirect_to spree.questionnaire_question_path @question.next
    else
      render :show
    end
  end

  protected

  def massage_params(params)
    if spree_current_user
      params[:question][:question_options_attributes].each do |k,question_option|
        question_option[:question_option_answers_attributes].each do |q, answer|
           params[:question][:question_options_attributes][k][:question_option_answers_attributes][q] = answer.merge({:user_id => spree_current_user.id})
        end
      end
    end
    params[:question]
  end

end
