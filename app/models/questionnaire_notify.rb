class QuestionnaireNotify < ActiveRecord::Base
  attr_accessible :email
  validates :email, presence: true
  validates :email, format: {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ } # e-mail regex
  has_and_belongs_to_many :question_option_answers
end
