class Spree::QuestionsController < Spree::StoreController

  def show
    @questionnaire = Questionnaire.get_questionnaire
    @question = @questionnaire.questions.first unless @questionnaire.nil?
    @question_option = @question.question_options.first unless @question.nil?
  end

  def update
    
  end

end
