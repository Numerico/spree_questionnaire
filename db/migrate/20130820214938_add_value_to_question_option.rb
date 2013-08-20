class AddValueToQuestionOption < ActiveRecord::Migration
  def change
    add_column :question_options, :value, :text
  end
end
