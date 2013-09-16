class CreateJoinTableNotifyAnswer < ActiveRecord::Migration
  def up
    create_table :question_option_answers_questionnaire_notifies do |t|
      t.references :questionnaire_notify
      t.references :question_option_answer
    end
  end

  def down
    drop_table :question_option_answers_questionnaire_notifies
  end
end
