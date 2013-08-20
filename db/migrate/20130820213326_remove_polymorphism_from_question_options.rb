class RemovePolymorphismFromQuestionOptions < ActiveRecord::Migration
  def up
    remove_column :question_options, :value_id
    remove_column :question_options, :value_type
  end

  def down
    add_column :question_options, :value_type, :string
    add_column :question_options, :value_id, :integer
  end
end
