class CreateAsciiais < ActiveRecord::Migration
  def change
    create_table :asciiais do |t|

      t.float :ir_a
      t.float :ir_d
      t.float :ir_p
      t.integer :min_p
      t.integer :attack_timing
      t.integer :games_played
      t.integer :wins

      t.timestamps
    end
  end
end
