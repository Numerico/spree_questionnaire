class QuestionOptionAnswer < ActiveRecord::Base
  belongs_to :question_option
  belongs_to :spree_user
  attr_accessible :answer
end
