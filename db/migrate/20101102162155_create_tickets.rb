class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      #t.references :student,  :null =>  false
      t.string  :student, :null =>  false
      #t.references :teacher
      t.string  :teacher
      #t.string  :course_id
      t.string  :course
      #t.references :responsible
      t.string  :responsible
      t.string  :corresponding_to
      t.text    :description
      t.string  :status

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
