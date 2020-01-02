class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.string :name, null: false, default: ""
      t.string :desc, null: false, default: "", limit:4000
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
