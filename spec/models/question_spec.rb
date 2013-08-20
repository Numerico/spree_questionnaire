require 'spec_helper'

describe Question do

  it "can add options" do
    question = create :question
    3.times do
      question.question_options << create(:question_option)
    end
    expect(question.question_options.size).to be(3)
  end

end
