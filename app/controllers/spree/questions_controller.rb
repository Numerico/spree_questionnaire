class Spree::QuestionsController < Spree::StoreController

  def show
    @question = Question.get_question params[:id]
    @next = @question.next
    @previous = @question.previous
    @question_option = @question.question_options.first unless @question.nil? #TODO NOT FIRST
  end

  def update
    
  end

end
