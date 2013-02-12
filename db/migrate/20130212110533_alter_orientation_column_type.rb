class AlterOrientationColumnType < ActiveRecord::Migration
  def up
    execute 'alter table card_images alter column orientation type varchar(255)'
    execute 'alter table card_images alter column image_type type varchar(255)'
  end

  def down
  end
end
