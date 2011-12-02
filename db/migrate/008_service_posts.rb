class ServicePosts < ActiveRecord::Migration
  def up
    change_table :posts do |t|
      t.references :service
    end
  end

  def down
    remove_column :posts, :service_id
  end
end
