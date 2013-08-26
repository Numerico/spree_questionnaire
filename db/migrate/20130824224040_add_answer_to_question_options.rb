class AddAnswerToQuestionOptions < ActiveRecord::Migration
  def change
    add_column :question_options, :answer, :text
  end
end
