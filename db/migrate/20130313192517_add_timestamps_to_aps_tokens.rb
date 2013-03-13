class AddTimestampsToApsTokens < ActiveRecord::Migration
  def change
    add_column :aps_tokens, :created_at, :datetime, null: false
    add_column :aps_tokens, :updated_at, :datetime, null: false
  end
end
