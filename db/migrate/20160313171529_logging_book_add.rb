class LoggingBookAdd < ActiveRecord::Migration
  def change
    change_table :books do |t|
      t.integer :user_add
    end
  end
end
