class ChangeDesignTypeColumnType < ActiveRecord::Migration
  def up
    execute 'alter table card_designs modify column design_type varchar(255) not null'
  end

  def down
    execute 'alter table card_designs modify column design_type integer not null'
  end
end
