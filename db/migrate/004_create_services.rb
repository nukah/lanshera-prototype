class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :login
      t.string :password
      t.references :user
      t.timestamps
    end
  end
end
