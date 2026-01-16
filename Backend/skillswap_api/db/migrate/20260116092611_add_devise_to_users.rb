class AddDeviseToUsers < ActiveRecord::Migration[8.1]
  def up
    # Only add columns that DO NOT already exist

    unless column_exists?(:users, :encrypted_password)
      add_column :users, :encrypted_password, :string, null: false, default: ""
    end

    unless column_exists?(:users, :jti)
      add_column :users, :jti, :string
      add_index  :users, :jti, unique: true
    end

    unless column_exists?(:users, :reset_password_token)
      add_column :users, :reset_password_token, :string
      add_index  :users, :reset_password_token, unique: true
    end

    unless column_exists?(:users, :reset_password_sent_at)
      add_column :users, :reset_password_sent_at, :datetime
    end

    unless column_exists?(:users, :remember_created_at)
      add_column :users, :remember_created_at, :datetime
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
