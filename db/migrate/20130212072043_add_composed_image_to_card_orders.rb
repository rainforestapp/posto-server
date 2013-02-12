class AddComposedImageToCardOrders < ActiveRecord::Migration
  def up
    add_column :card_designs, :composed_full_photo_image_id, :integer, limit:8, null:false
    add_column :card_designs, :edited_full_photo_image_id, :integer, limit:8, null:false
    add_index :card_designs, :composed_full_photo_image_id
    add_index :card_designs, :edited_full_photo_image_id

    execute "alter table card_designs alter column edited_full_photo_image_id set not null"
    execute "alter table card_designs alter column original_full_photo_image_id set not null"
    execute "alter table card_designs alter column design_type set not null"

    remove_column :card_designs, :edited_photo_image_id
    remove_column :card_designs, :editied_full_photo_image_id
    remove_column :card_designs, :original_photo_image_id
    remove_column :card_designs, :printable_image_id
    remove_column :card_designs, :printable_full_image_id
  end

  def down
    remove_column :card_designs, :composed_full_photo_image_id
    remove_column :card_designs, :edited_full_photo_image_id
    add_column :card_designs, :edited_photo_image_id, :integer, limit: 8, null: false
    add_column :card_designs, :original_photo_image_id, :integer, limit: 8, null: false
    add_column :card_designs, :editied_full_photo_image_id, :integer, limit: 8, null: false
    add_column :card_designs, :printable_image_id, :integer, limit: 8, null: false
    add_column :card_designs, :printable_full_image_id, :integer, limit: 8, null: false
  end
end
