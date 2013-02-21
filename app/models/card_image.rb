require "rmagick"

class CardImage < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :app, :uuid, :width, :height, :orientation, :image_type, :image_format

  belongs_to :author_user, class_name: "User"
  belongs_to :app

  symbolize :image_type, 
            in: [:original_full_photo, :edited_full_photo, :composed_full_photo, :card_front, :card_back],
            validates: true

  symbolize :orientation, 
            in: [:up, :down, :left, :right, 
                 :up_mirrored, :down_mirrored, :left_mirrored, :right_mirrored],
            validates: true

  symbolize :image_format, in: [:jpg, :png, :pdf], validates: true

  before_save(on: create) do
    self.uuid ||= SecureRandom.hex
  end

  RMAGICK_IMAGE_FORMAT_MAP = {
    "jpeg" => :jpg,
    "png" => :png,
    "pdf" => :pdf,
  }

  def content_type
    case image_format
    when :jpg
      "image/jpeg" 
    when :png
      "image/png" 
    when :pdf
      "application/pdf" 
    else
      raise "unknown image format #{image_format}"
    end
  end

  def path
    "#{uuid[0...2]}/#{uuid[2...4]}/#{uuid[4...6]}/#{uuid}.#{self.image_format}"
  end

  def public_url
    "http://#{CONFIG.card_image_host}/#{self.path}"
  end
end
