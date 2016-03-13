class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
        t.string :auth_token
        #Really? I can't naming my column 'name'?
        t.integer :perm, :user_id, :typeToken
        t.timestamps
        t.timestamp :last_req
    end
  end
end
