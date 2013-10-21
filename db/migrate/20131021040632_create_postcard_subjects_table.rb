require "migrations/migration_helpers"
class CreatePostcardSubjectsTable < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :postcard_subjects do |t|
      t.integer :user_id, null: false, limit: 8
      t.integer :app_id, null: false, limit: 8
      t.string :name, null: false, limit: 1024
      t.string :postcard_subject_type, null: false, limit: 128
      t.datetime :birthday, null: false
      t.string :gender, null: false, limit: 128
      t.timestamps
    end

    create_posto_table :postcard_subject_states do |t|
      t.integer :postcard_subject_id, null: false, limit: 8
      t.string :state, null: false, limit: 64
      t.boolean :latest, null: false
      t.timestamps
    end

    add_index :postcard_subjects, :user_id
    add_index :postcard_subjects, :birthday
    add_index :postcard_subject_states, :postcard_subject_id
  end

  def down
    drop_table :postcard_subjects
    drop_table :postcard_subject_states
  end
end
