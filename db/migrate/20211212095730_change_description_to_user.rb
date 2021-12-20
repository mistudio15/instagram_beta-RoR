class ChangeDescriptionToUser < ActiveRecord::Migration[6.1]
  def change
    change_column(:users, :description, :text)
  end
end
