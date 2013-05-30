require "migrations/migration_helpers"

class AddEmailTasks < ActiveRecord::Migration
  include MigrationHelpers

  def up
    create_posto_table :outgoing_email_tasks do |t|
      t.string :workload_id, null: false, limit: 512
      t.string :uid, null: false, limit: 64
      t.integer :workload_index, null: false
      t.string :email_type, null: false, limit: 64
      t.string :email_variant, null: false, limit: 64
      t.string :email_args, null: false, limit: 2048
      t.integer :recipient_user_id, null: false, limit: 8
      t.timestamps
    end

    add_index :outgoing_email_tasks, [:workload_id, :workload_index]
    add_index :outgoing_email_tasks, :recipient_user_id

    create_posto_table :outgoing_email_task_states do |t|
      t.integer :outgoing_email_task_id, null: false, limit: 8
      t.string :state, null: false, limit: 64
      t.boolean :latest, null: false
      t.timestamps
    end

    add_index :outgoing_email_task_states, :outgoing_email_task_id

    create_posto_table :email_opt_outs do |t|
      t.integer :recipient_user_id, null: false, limit: 8
      t.string :email_class, null: false, limit: 64 # multiple email_types to an email_class
      t.timestamps
    end

    add_index :email_opt_outs, :recipient_user_id

    create_posto_table :email_opt_out_states do |t|
      t.integer :email_opt_out_id, null: false, limit: 8
      t.string :state, null: false, limit: 64
      t.boolean :latest, null: false
      t.timestamps
    end

    add_index :email_opt_out_states, :email_opt_out_id
  end

  def down
    drop_table :outgoing_email_tasks
    drop_table :outgoing_email_task_states
    drop_table :email_opt_outs
    drop_table :email_opt_out_states
  end
end
