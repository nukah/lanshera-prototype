class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user
      t.string :subject
      t.text :text
      t.datetime :time
      t.integer :anum
      t.integer :post_id

      t.timestamps
    end
  end
end
