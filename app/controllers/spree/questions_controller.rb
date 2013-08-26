class Spree::QuestionsController < Spree::StoreController

  def show
    @question = Question.get_question params[:id]
    @next = @question.next
    @previous = @question.previous
  end

  def update
    @question = Question.get_question params[:id]
    if @question.update_attributes(params[:question])
      redirect_to spree.questionnaire_question_path @question.next
    else
      render :show
    end
  end

end
