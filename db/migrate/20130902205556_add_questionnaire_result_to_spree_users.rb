class AddQuestionnaireResultToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :questionnaire_result, :string
  end
end
