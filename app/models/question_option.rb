class QuestionOption < ActiveRecord::Base
  belongs_to :question
  has_many :question_option_answers

  attr_accessible :question_option_answers_attributes
  accepts_nested_attributes_for :question_option_answers
end
