class CreateBooks < ActiveRecord::Migration

  def change
    create_table :books do |t|
      t.string :name, :annotation, :author
      t.text :other_text, :table_of_contents
      t.integer :search_index
      t.timestamps
    end
    add_index :books, :search_index
  end
end
