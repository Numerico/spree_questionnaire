require 'spec_helper'

describe QuestionOption do

  it "uses single table inheritance" do
    questions = []
    questions << create(:question_option)
    questions << create(:question_option_integer)
    questions << create(:question_option_string)
    questions.each do |question|
      expect(question).to be_a_kind_of(described_class)
    end
  end

end
