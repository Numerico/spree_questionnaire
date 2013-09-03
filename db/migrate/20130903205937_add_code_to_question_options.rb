class AddCodeToQuestionOptions < ActiveRecord::Migration
  def change
    add_column :question_options, :code, :string
  end
end
