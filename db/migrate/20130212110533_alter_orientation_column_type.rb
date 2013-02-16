class AlterOrientationColumnType < ActiveRecord::Migration
  def up
    execute 'alter table card_images modify column orientation varchar(255) not null'
    execute 'alter table card_images modify column image_type varchar(255) not null'
  end

  def down
  end
end
