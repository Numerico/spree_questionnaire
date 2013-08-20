class AddTypeToQuestionOptions < ActiveRecord::Migration
  def change
    add_column :question_options, :type, :string
  end
end
