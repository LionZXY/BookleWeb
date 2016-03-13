class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, :pswd
      t.integer :perm, :ip
      t.timestamps
    end
  end
end
