class AddPictureToHam < ActiveRecord::Migration[5.2]
  def change
    add_column :hams, :picture, :string
  end
end
