class RemoveUserFromQuestionnaire < ActiveRecord::Migration
  def up
    remove_column :questionnaires, :is_model
    remove_column :questionnaires, :user_id
  end

  def down
    add_column :questionnaires, :user_id, :integer
    add_index :questionnaires, :user_id
    add_column :questionnaires, :is_model, :boolean
  end
end
