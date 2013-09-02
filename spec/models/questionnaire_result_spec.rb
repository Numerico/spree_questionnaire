require 'spec_helper'

describe QuestionnaireResult do

  it "implements singleton interface" do
    QuestionnaireResult.load_data nil, nil
    qr1 = QuestionnaireResult.instance
    qr2 = QuestionnaireResult.instance
    expect(qr1).to be qr2
  end

  context "simple data" do
    before :all do
      @tree_attributes = ['one', 'two']
      @training = [
        [1, 1, true],
        [1, 2, true],
        [2, 1, false],
        [2, 2, false]
      ]
      QuestionnaireResult.load_data @tree_attributes, @training
    end
    it "receives params" do
      qr  = QuestionnaireResult.instance
      expect(qr.tree_attributes.count).to eq 2
      expect(qr.training.count).to eq 4
    end
    it "uses decisiontree gem" do
      qr = QuestionnaireResult.instance
      expect(qr.decision_tree).to be_a_kind_of(DecisionTree::ID3Tree)
    end
    it "returns a result" do
      test = [2, 1]
      result = QuestionnaireResult.instance.resolve test
      expect(result).to be false
    end
  end

end