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

  it "has an integer type" do
    int = create :question_option_integer
    expect(int.value).to be_a_kind_of(Integer)
  end
  it "has a string type" do
    str = create :question_option_string
    expect(str.value).to be_a_kind_of(String)
  end

  it "has an array type" do
    q = create :question_option_array
    expect(q.value).to be_a_kind_of(Array)
  end

end
