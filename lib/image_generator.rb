require "tempfile"
require "open-uri"
require "uri"

class ImageGenerator
  protected

  def with_file_for_url(url)
    with_tempfile do |file|
      open(url) do |data|
        file.write(data.read)
        file.close
        yield file
      end
    end
  end

  def with_closed_tempfile
    with_tempfile do |file|
      file.close
      yield(file)
    end
  end

  def with_tempfile
    Tempfile.open(SecureRandom.hex) do |file|
      file.binmode

      begin
        yield(file)
      ensure
        File.unlink(file.path) if File.exist?(file.path)
      end
    end
  end

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
