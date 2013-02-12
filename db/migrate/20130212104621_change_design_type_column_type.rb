class ChangeDesignTypeColumnType < ActiveRecord::Migration
  def up
    execute 'alter table card_designs alter column design_type type varchar(255)'
  end

  def down
    execute 'alter table card_designs alter column design_type type integer'
  end
end
