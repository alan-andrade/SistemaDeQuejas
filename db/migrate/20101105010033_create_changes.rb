class CreateChanges < ActiveRecord::Migration
  def self.up
    create_table :changes do |t|
      t.text :intern_comments
      t.text :extern_comments
      t.string :change_type
      t.references  :responsible
      t.references  :ticket

      t.timestamps
    end
  end

  def self.down
    drop_table :changes
  end
end
