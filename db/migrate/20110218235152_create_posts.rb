class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :responsible_id
      t.integer :student_id
      t.string  :corresponding_to,  :limit  =>  20
      t.string  :title,             :limit  =>  100
      t.text    :description,       :limit  =>  300
      t.string  :status,            :limit  =>  20
      t.string  :change_type,       :limit  =>  20
      t.integer :ticket_id
      t.integer :change_id
      t.text    :body,              :limit  =>  500
      t.string  :type,              :limit  =>  15  # Needed by class inheritance
      
      t.timestamps
    end
    add_index :posts, :id
    add_index :posts, :type
  end

  def self.down
    drop_table :posts
  end
end
