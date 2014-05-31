class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :content
      t.boolean :isPublic

      t.timestamps
    end
  end
end
