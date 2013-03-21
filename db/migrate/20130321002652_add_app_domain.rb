class AddAppDomain < ActiveRecord::Migration
  def up
    add_column :apps, :domain, :string, null: false
    execute "update apps set domain = 'lulcards.com'"
  end

  def down
    remove_column :apps, :domain
  end
end
