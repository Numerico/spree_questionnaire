class QuestionOption < ActiveRecord::Base
  belongs_to :question
  has_many :question_option_answers

  attr_accessible :question_option_answers_attributes
  accepts_nested_attributes_for :question_option_answers

  serialize :value

end

class QuestionOptionInteger < QuestionOption; end
class QuestionOptionString < QuestionOption; end
class QuestionOptionArray < QuestionOption; end
class QuestionOptionHash < QuestionOption; end
class QuestionOptionHash < QuestionOption; end
class QuestionOptionRadioButton < QuestionOption; end
class QuestionOptionRange < QuestionOption; end