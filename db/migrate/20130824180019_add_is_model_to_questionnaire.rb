class AddIsModelToQuestionnaire < ActiveRecord::Migration
  def change
    add_column :questionnaires, :is_model, :boolean, default: false
  end
end
