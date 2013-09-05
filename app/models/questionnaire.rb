class Questionnaire < ActiveRecord::Base

  has_many :questions
  has_many :question_options, through: :questions

  def ordered_questions
    self.questions.order("position")
  end

  def self.get_questionnaire
    self.last
  end

end
