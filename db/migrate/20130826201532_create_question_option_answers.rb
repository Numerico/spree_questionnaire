class CreateQuestionOptionAnswers < ActiveRecord::Migration
  def change
    create_table :question_option_answers do |t|
      t.references :question_option
      t.references :user
      t.timestamps
    end
    add_index :question_option_answers, :question_option_id
    add_index :question_option_answers, :user_id
  end
end
