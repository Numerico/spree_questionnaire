class AddAnswerToQuestionOptionAnswers < ActiveRecord::Migration
  def change
    add_column :question_option_answers, :answer, :text
  end
end
