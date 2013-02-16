require "migrations/migration_helpers"

class CreateCardImages < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :card_images do |t|
      t.integer :author_user_id, null: false, limit: 8
      t.integer :app_id, null: false, limit: 8
      t.string :uuid, null: false
      t.integer :width, null: false
      t.integer :height, null: false
      t.integer :orientation, null: false
      t.integer :image_type, null: false

      t.timestamps
    end

    [:author_user_id].each do |c|
       add_index :card_images, c
    end

    add_index :card_images, :uuid, :unique => true
  end

  def down
    drop_table :card_images
  end
end
