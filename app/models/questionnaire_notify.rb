class QuestionnaireNotify < ActiveRecord::Base
  attr_accessible :email
  has_and_belongs_to_many :question_option_answers
end
