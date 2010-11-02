class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer :student_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
