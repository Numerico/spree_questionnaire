class Spree::QuestionnairesController < Spree::StoreController
  def show
    @questionnaire = Questionnaire.first
    @question = @questionnaire.questions.first unless @questionnaire.nil?
    @question_option = @question.question_options.first unless @question.nil?
  end
end