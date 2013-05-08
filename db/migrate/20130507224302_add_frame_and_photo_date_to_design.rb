class AddFrameAndPhotoDateToDesign < ActiveRecord::Migration
  def change
    add_column :card_designs, :frame_type, :string, limit: 128
    add_column :card_designs, :photo_taken_at, :datetime
  end
end
