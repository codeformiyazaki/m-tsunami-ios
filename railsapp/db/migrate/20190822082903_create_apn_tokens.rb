class CreateApnTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :apn_tokens do |t|
      t.string :token
      t.string :type

      t.timestamps
    end
  end
end
