class AllowNullEditedPhotoInDesign < ActiveRecord::Migration
  def up
    execute 'alter table card_designs alter column edited_full_photo_image_id drop not null'
  end

  def down
    execute 'alter table card_designs alter column edited_full_photo_image_id set not null'
  end
end
