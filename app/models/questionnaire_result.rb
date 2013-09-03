require 'decisiontree'

class QuestionnaireResult
  include Singleton

  # load data once to class variables
  def self.load_data(tree_attributes, training)
    @@tree_attributes = tree_attributes || []
    @@training = training || []
    @@decision_tree = DecisionTree::ID3Tree.new @@tree_attributes, @@training, nil, :discrete # TODO default nil?
    @@decision_tree.train
  end

  # do your magic
  def resolve(test)
    @@decision_tree.predict test
  end

  # these are for testing purposes only
  # TODO attr_accessor :attributes, :training, :decision_tree & def initialize...
  def tree_attributes
    @@tree_attributes
  end
  def training
    @@training
  end
  def decision_tree
    @@decision_tree
  end

end