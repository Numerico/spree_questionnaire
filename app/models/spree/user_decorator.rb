module Spree
  User.class_eval do
    has_many :question_option_answers
    has_many :question_options, :through => :question_option_answers
  end
end