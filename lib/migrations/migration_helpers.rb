module MigrationHelpers
  def create_posto_table(table, params={}, &block)
    primary_key_column = (table.to_s.singularize + "_id").to_sym
    params[:id] = false
    params[:primary_key] = primary_key_column

    create_table table, params do |t|
      t.integer primary_key_column, null: false, limit: 8, auto_increment: true
      yield t
      t.text :meta
    end

    execute "alter table #{table} modify column #{primary_key_column} bigint not null auto_increment primary key"
  end
end
