class AddIntroductionToQuestionnaire < ActiveRecord::Migration
  def change
    add_column :questionnaires, :introduction, :text
  end
end
