class Spree::QuestionnairesController < Spree::StoreController

  def show
    @questionnaire = Questionnaire.get_questionnaire
  end

end
