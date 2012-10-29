class CreateLdhs < ActiveRecord::Migration
  def change
    create_table :ldhs do |t|
      t.string :name
      t.integer :points
      t.integer :difficulty
      t.timestamps
    end
  end
end
