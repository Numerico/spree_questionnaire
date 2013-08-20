class Questionnaire < ActiveRecord::Base

  has_many :questions

  def ordered_questions
    self.questions.order("position")
  end

end
