class RemoveStatusFromTransactions < ActiveRecord::Migration
  def up
    remove_column :transactions, :status
  end

  def down
    remove_column :transactions, :status, :string
  end
end
