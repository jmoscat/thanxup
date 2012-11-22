class DeviseCreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Rememberable
      t.datetime :remember_created_at

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Trackable
      t.integer  :sign_in_count, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.string :first_name
      t.string :last_name
      t.string :suffix
      t.string :prefix
      t.string :company_name
      t.string :city
      t.string :state
      t.string :phone_number
      t.boolean :allow_phone_contact, default: false, null: false
      t.boolean :approved, default: false, null: false
      t.timestamps
      t.attachment :logo #for paperclip gem
    end

    add_index :owners, :email,                unique: true
    add_index :owners, :reset_password_token, unique: true
  end
end
