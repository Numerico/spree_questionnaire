class RemoveAnswerFromQuestionOptions < ActiveRecord::Migration
  def up
    remove_column :question_options, :answer
  end

  def down
    add_column :question_options, :answer, :text
  end
end
