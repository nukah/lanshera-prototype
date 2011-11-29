class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :user
      t.text :text
      t.text :url
      t.references :post

      t.timestamps
    end
    add_index :comments, :post_id
  end
end
