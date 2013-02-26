require "tempfile"
require "open-uri"
require "uri"

class ImageGenerator
  include TempFileHelpers

  protected

  def with_image_for_url(url)
    with_file_for_url(url) do |file|
      with_image(file.path) do |image|
        yield(image)
      end
    end
  end

  def with_image(path)
    image = nil

    begin 
      image = Magick::Image.read(path).first
      yield(image)
    ensure
      image.try(:destroy!)
    end
  end
end
