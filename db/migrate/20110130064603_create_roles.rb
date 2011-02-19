class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name, :null =>  false,  :limit  =>  25
    end
  end

  def self.down
    drop_table :roles
  end
end
