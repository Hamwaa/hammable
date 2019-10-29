class CreateHams < ActiveRecord::Migration[5.2]
  def change
    create_table :hams do |t|
      t.text :message
      t.timestamps
    end
  end
end
