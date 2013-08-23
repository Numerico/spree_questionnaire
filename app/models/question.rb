class Question < ActiveRecord::Base
  belongs_to :questionnaire
  has_many :question_options
  attr_accessible :text

  def previous
    self.questionnaire.questions.where(position: self.position-1).first
  end

  def next
    self.questionnaire.questions.where(position: self.position+1).first
  end

  def self.get_question(id)
    Questionnaire.get_questionnaire.questions.where(id: id).first
  end

end
