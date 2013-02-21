class AddImageFormatToCardImages < ActiveRecord::Migration
  def up
    add_column :card_images, :image_format, :string
    execute "update card_images set image_format = 'jpg'"
    execute "alter table card_images modify column image_format varchar(255) not null"
  end

  def down
    remove_column :card_images, :image_format
  end
end
