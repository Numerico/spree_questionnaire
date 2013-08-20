class QuestionOption < ActiveRecord::Base
  belongs_to :question
  attr_accessible :type, :value
end
