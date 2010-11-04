class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer :student_id
      t.integer :teacher_id
      t.string  :course_id
      t.integer :responsible_id
      t.string  :ticket_type
      t.text    :description

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
