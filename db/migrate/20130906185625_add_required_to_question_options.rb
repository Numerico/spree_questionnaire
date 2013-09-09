class AddRequiredToQuestionOptions < ActiveRecord::Migration
  def change
    add_column :question_options, :required, :boolean, null: false, default: false
  end
end
