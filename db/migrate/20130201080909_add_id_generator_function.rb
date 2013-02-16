class AddIdGeneratorFunction < ActiveRecord::Migration
  def up
    #execute "create schema posto0"
#    execute "create sequence posto0.table_id_seq"
#
#    execute <<-END
#CREATE OR REPLACE FUNCTION posto0.next_id(OUT result bigint) AS $$
#DECLARE
#    our_epoch bigint := 1314220021721;
#    seq_id bigint;
#    now_millis bigint;
#    shard_id int := 0;
#BEGIN
#    SELECT nextval('posto0.table_id_seq') % 1024 INTO seq_id;
#
#    SELECT FLOOR(EXTRACT(EPOCH FROM clock_timestamp()) * 1000) INTO now_millis;
#    result := (now_millis - our_epoch) << 23;
#    result := result | (shard_id << 10);
#    result := result | (seq_id);
#END;
#$$ LANGUAGE PLPGSQL;
#END
  end

  def down
    #execute <<-END
    #DROP FUNCTION posto0.next_id();
    #END
  end
end
