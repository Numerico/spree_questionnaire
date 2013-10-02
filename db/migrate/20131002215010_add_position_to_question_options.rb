class AddPositionToQuestionOptions < ActiveRecord::Migration
  def change
    add_column :question_options, :position, :integer
  end
end
