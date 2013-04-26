class AddPhotoIsUserGeneratedToCardDesign < ActiveRecord::Migration
  def change
    add_column :card_designs, :photo_is_user_generated, :boolean
  end
end
