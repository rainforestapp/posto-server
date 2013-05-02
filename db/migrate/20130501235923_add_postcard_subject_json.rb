class AddPostcardSubjectJson < ActiveRecord::Migration
  def up
    add_column :card_designs, :postcard_subject_json, :string, limit: 4096
  end

  def down
    remove_column :card_designs, :postcard_subject_json
  end
end
