require 'spec_helper'

describe Questionnaire do

  it "can add questions" do
    questionnaire = create :questionnaire
    3.times do
      questionnaire.questions << create(:question)
    end
    expect(questionnaire.questions.size).to be(3)
  end

  it "stores questions ordered" do
    questionnaire = create :questionnaire
    questions = []
    10.times do
      questions << create(:question)
    end
    questionnaire.questions = questions.shuffle
    #should match one by one
    questionnaire.ordered_questions.each_with_index do |question, index|
      expect(question).to eq(questions[index])
    end
  end

  it "belongs to a user" do
    questionnaire = create :questionnaire
    expect(questionnaire.user).to be_a_kind_of(Spree::User)
  end

  it "is a model if not associated to any user" do
    questionnaire = create :questionnaire_model
    expect(questionnaire.user).to be(nil)
  end

end