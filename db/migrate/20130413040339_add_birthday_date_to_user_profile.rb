class AddBirthdayDateToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :birthday_date, :string
    add_column :user_profiles, :birthday_day, :integer
    add_column :user_profiles, :birthday_month, :integer
    add_column :user_profiles, :birthday_year, :integer

    add_index :user_profiles, [:birthday_day, :birthday_month]
  end
end
