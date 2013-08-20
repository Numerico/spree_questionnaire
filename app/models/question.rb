class Question < ActiveRecord::Base
  belongs_to :questionnaire
  has_many :question_options
  attr_accessible :text
end
