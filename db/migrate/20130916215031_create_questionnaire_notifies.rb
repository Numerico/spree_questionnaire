class CreateQuestionnaireNotifies < ActiveRecord::Migration
  def change
    create_table :questionnaire_notifies do |t|
      t.string :email

      t.timestamps
    end
  end
end
