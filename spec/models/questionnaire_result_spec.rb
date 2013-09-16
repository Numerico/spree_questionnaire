require 'spec_helper'

describe QuestionnaireResult do

  it "is not a singleton" do # TODO singletons in rails?
    qr1 = QuestionnaireResult.new
    qr2 = QuestionnaireResult.new
    expect(qr1).to_not be qr2
  end

  context "simple data" do
    it "loads from config/spree_questionnaire_result.yml" do
      qr  = QuestionnaireResult.new
      expect(qr.tree_attributes.count).to eq 2
      expect(qr.training.count).to eq 5
    end
    it "uses decisiontree gem" do
      qr = QuestionnaireResult.new
      expect(qr.decision_tree).to be_a_kind_of(DecisionTree::ID3Tree)
    end
    it "returns a result" do
      test = ["2", "1"]
      result = QuestionnaireResult.new.resolve test
      expect(result).to eq false
    end
  end

end