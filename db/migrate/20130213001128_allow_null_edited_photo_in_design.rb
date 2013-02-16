class AllowNullEditedPhotoInDesign < ActiveRecord::Migration
  def up
    execute 'alter table card_designs modify column edited_full_photo_image_id bigint'
  end

  def down
    execute 'alter table card_designs modify column edited_full_photo_image_id bigint'
  end
end
