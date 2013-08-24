class AddUserRefToQuestionnaires < ActiveRecord::Migration
  def change
    add_column :questionnaires, :user_id, :integer
    add_index :questionnaires, :user_id
  end
end
