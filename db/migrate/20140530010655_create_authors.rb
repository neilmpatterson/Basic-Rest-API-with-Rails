class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :firstname
      t.string :lastname
      t.string :middlename
      t.string :title
      t.string :source

      t.timestamps
    end
  end
end
