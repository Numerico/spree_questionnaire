require 'decisiontree'

class QuestionnaireResult

  attr_accessor :tree_attributes, :training, :decision_tree

  TRAINING_DATA = "config/spree_questionnaire_result.yml"

  # TODO HOW TO INITIALIZE IT ONCE PER APP
  # (SINGLETON GETS RECREATED AT EACH REQUEST)
  def initialize
    if File.exist? TRAINING_DATA
      data = YAML.load_file TRAINING_DATA
      load_data data["attributes"], data["training"]
    end
  end

  # do your magic
  def resolve(test)
    @decision_tree.predict test
  end

   # no protected to load it from tests
  def load_data(tree_attributes, training)
    @tree_attributes = tree_attributes || []
    @training = training || []
    @decision_tree = DecisionTree::ID3Tree.new @tree_attributes, @training, nil, :discrete # TODO default nil?
    @decision_tree.train
  end

end