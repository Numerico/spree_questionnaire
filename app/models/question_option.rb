class QuestionOption < ActiveRecord::Base
  belongs_to :question
  attr_accessible :answer
end
