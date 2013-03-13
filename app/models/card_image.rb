class CardImage < ActiveRecord::Base
  include AppendOnlyModel

  CARD_ASPECT_RATIO = 1.4
  CARD_PREVIEW_HEIGHT = 384
  CARD_PREVIEW_WIDTH = (CARD_PREVIEW_HEIGHT / CARD_ASPECT_RATIO).floor

  attr_accessible :app, :uuid, :width, :height, :orientation, :image_type, :image_format

  belongs_to :author_user, class_name: "User"
  belongs_to :app

  symbolize :image_type, 
            in: [:original_full_photo, :edited_full_photo, :composed_full_photo, 
                 :card_front, :card_back, :card_preview, :treated_card_preview],
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
  
  def filename
    "#{uuid}.#{image_format}"
  end

  def path
    "#{uuid[0...2]}/#{uuid[2...4]}/#{uuid[4...6]}/#{filename}"
  end

  def public_url
    "http://#{CONFIG.card_image_host}/#{self.path}"
  end

  def public_ssl_url
    "https://#{CONFIG.card_image_host}/#{self.path}"
  end
end
