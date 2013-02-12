class ChangeTypeOnOriginalFullPhotoImageId < ActiveRecord::Migration
  def up
    execute 'alter table card_designs alter column original_full_photo_image_id type bigint'
  end

  def down
  end
end
