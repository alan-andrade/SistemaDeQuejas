class AddTicketTakerToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :ticket_taker, :boolean, :default=>false
  end

  def self.down
    remove_column :users, :ticket_taker
  end
end
