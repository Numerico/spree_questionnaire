require 'spec_helper'

describe QuestionOptionAnswer do

  it "can be associated to an user" do
    answer = create :question_option_answer
    user = create :user
    answer.user = user
    user.save!
    expect(answer.user).to be_a_kind_of(Spree.user_class)
  end

end
