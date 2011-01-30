class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :id=>nil, :primary_key=>'id' do |t|
      t.string      :id     , :null =>  false
      t.string      :email  , :null=>false
      t.string      :name   , :null=>false
      t.references  :role   , :null =>  false      

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
