class Questionnaire < ActiveRecord::Base

  has_many :questions

  def ordered_questions
    self.questions.order("position")
  end

  def self.get_questionnaire
    self.first
  end

end
