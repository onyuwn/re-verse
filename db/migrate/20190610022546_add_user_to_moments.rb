class AddUserToMoments < ActiveRecord::Migration[5.2]
  def change
    add_column :moments, :user, :string
  end
end
