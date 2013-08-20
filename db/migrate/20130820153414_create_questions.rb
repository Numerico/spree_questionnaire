class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :text
      t.references :questionnaire

      t.timestamps
    end
    add_index :questions, :questionnaire_id
  end
end
