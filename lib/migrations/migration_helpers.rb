module MigrationHelpers
  def create_sharded_table(table, params={}, &block)
    primary_key_column = (table.to_s.singularize + "_id").to_sym
    params[:id] = false

    create_table table, params do |t|
      t.integer primary_key_column, null: false, limit: 8
      yield t
      t.hstore :meta
    end

    execute "alter table #{table} alter column #{primary_key_column} set default next_id()"
    execute "alter table #{table} add primary key (#{primary_key_column})"
  end
end
