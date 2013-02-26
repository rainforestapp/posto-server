module TempFileHelpers
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

end
