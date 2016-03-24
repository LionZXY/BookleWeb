class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
      t.integer :auth_token, :limit => 8
      #Really? I can't naming my column 'type'?
      t.integer :perm, :user_id, :typeToken, :uniq_id
      t.timestamps
      t.timestamp :last_req
    end
  end
end
