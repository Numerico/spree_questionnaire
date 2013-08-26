class QuestionOptionAnswer < ActiveRecord::Base
  belongs_to :question_option
  belongs_to :user, class_name: Spree.user_class.to_s
  attr_accessible :answer
end