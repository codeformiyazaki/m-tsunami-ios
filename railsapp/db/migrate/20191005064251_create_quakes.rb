class CreateQuakes < ActiveRecord::Migration[5.2]
  def change
    create_table :quakes do |t|
      t.integer :device_id
      t.float :elapsed
      t.float :p
      t.float :s

      t.timestamps
    end
  end
end
