class Questionnaire < ActiveRecord::Base

  belongs_to :user, class_name: Spree.user_class.to_s
  has_many :questions

  validates :user, presence: true, unless: Proc.new {|q| q.is_model}

  def ordered_questions
    self.questions.order("position")
  end

  def self.get_questionnaire
    self.first
  end

end
