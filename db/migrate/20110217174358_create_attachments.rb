class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.references  :post,    :null =>  false
      t.binary :content,      :limit=>10.megabyte
      t.string :file_name,    :limit  =>  100
      t.string :content_type, :limit=>  20

      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
