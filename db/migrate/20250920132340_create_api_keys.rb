class CreateApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :api_keys do |t|
      t.string :key, null: false
      t.string :client, null: false
      t.timestamp :deactivated_at

      t.timestamps

      t.index :key, unique: true
    end
  end
end
