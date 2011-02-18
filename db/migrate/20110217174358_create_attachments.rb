class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.binary :content,  :limit=>10.megabyte
      t.references  :ticket, :change
      t.string :file_name
      t.string :content_type

      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
