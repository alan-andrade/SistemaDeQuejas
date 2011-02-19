class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|      
      t.string      :uid    , :null =>  false
      t.string      :mail   , :null=>   false,  :limit=>50
      t.string      :name   , :null=>   false,  :limit=>100
      t.references  :role   , :null =>  false      

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
