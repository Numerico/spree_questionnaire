class Question < ActiveRecord::Base

  belongs_to :questionnaire
  has_many :question_options

  attr_accessible :text, :question_options_attributes
  accepts_nested_attributes_for :question_options

  def previous
    self.questionnaire.questions.where(position: self.position-1).first
  end

  def next
    self.questionnaire.questions.where(position: self.position+1).first
  end

  def is_first?
    self == self.questionnaire.ordered_questions.first
  end

  def self.get_question(id)
    #Questionnaire.get_questionnaire.questions.where(id: id).first TODO
    Question.find id
  end

end
