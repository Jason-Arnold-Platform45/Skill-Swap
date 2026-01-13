class CreateSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :skills do |t|
      t.string :title
      t.text :description
      t.string :skill_type
      t.references :user, null: false, foreign_key: true
      t.datetime :deleted

      t.timestamps
    end
  end
end
