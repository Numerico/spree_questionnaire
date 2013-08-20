class RemoveTypeFromQuestionOptions < ActiveRecord::Migration
  def up
    remove_column :question_options, :type
  end

  def down
    add_column :question_options, :type, :string
  end
end
