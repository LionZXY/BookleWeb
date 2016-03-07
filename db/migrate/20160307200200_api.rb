class Api < ActiveRecord::Migration
  def change
    create_table :auth do |t|
      t.string :auth_token, :user_login
      t.integer :permission
    end
    create_table :usr do |t|
      t.string :login, :pswd_md5
      t.integer :perm
    end
  end
end
