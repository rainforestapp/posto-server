class DropBirthdayDateFromUserProfiles < ActiveRecord::Migration
  def up
    remove_column :user_profiles, :birthday_date
  end

  def down
    add_column :user_profiles, :birthday_date, :string
  end
end
