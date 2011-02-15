class AddTitleToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :title, :string, :null=>false, :limit=>50, :default=>''
  end

  def self.down
    remove_column :tickets, :title
  end
end
