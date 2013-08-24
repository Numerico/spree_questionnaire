class Spree::QuestionsController < Spree::StoreController

  def show
    @question = Question.get_question params[:id]
    @next = @question.next
    @previous = @question.previous
  end

  def update
    @question = Question.get_question params[:id]
    redirect_to spree.questionnaire_question_path @question.next
  end

end
