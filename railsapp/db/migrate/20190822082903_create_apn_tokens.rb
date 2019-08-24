class CreateApnTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :apn_tokens do |t|
      t.string :token
      t.string :purpose
      t.string :memo

      t.timestamps
    end
  end
end
