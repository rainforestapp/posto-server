class AddAppIdToApps < ActiveRecord::Migration
  def up
    add_column :apps, :apple_app_id, :string, null:false
    execute "update apps set apple_app_id = '585112745'"
  end
  
  def down
    remove_column :apps, :app_id
  end
end
