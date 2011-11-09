class CreateResumes < ActiveRecord::Migration
  def change
    create_table :resumes do |t|
      t.string, :firstname
      t.string, :surname
      t.text, :about
      t.text, :info
      t.string :photo
    end
  end
end
