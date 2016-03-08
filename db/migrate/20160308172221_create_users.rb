class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, :pswd_md5
      t.integer :perm
      t.timestamps
    end
  end
end
