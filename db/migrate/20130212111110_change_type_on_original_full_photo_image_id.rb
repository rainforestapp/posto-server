class ChangeTypeOnOriginalFullPhotoImageId < ActiveRecord::Migration
  def up
    execute 'alter table card_designs modify column original_full_photo_image_id bigint not null'
  end

  def down
  end
end
