class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
        t.string :auth_token, :user_login
        t.integer :permission
        t.timestamps
    end
  end
end
