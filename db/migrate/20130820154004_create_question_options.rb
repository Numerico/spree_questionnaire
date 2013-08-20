class CreateQuestionOptions < ActiveRecord::Migration
  def change
    create_table :question_options do |t|
      t.string :type
      t.references{polymorphic} :value
      t.references :question

      t.timestamps
    end
    add_index :question_options, :question_id
  end
end
