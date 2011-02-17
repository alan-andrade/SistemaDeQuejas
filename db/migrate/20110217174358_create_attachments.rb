class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.binary :file
      t.references  :ticket, :change
      t.string :file_name
      t.string :extension

      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
