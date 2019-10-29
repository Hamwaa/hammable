class AlterHamsAddUserId < ActiveRecord::Migration[5.2]
  def change
    add_column :hams, :user_id, :integer
    add_index :hams, :user_id
  end
end
