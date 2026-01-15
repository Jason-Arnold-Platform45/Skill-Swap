class CreateMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :matches do |t|
      t.references :requester, null: false, foreign_key: { to_table: :users }
      t.references :provider, null: false, foreign_key: { to_table: :users }
      t.references :skill, null: false, foreign_key: true
      t.string :status, default: "pending"

      t.timestamps
    end

    add_index :matches, [:requester_id, :skill_id], unique: true
  end
end
