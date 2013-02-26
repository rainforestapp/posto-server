require "open-uri"

class AmazingMailActivities
  include TempFileHelpers

  def az_user
    ENV["AMAZING_MAIL_USER"]
  end

  def az_password
    ENV["AMAZING_MAIL_PASSWORD"]
  end

  def az_dmid
    ENV["AMAZING_MAIL_DMID"]
  end

  def submit_images_to_amazing_mail(card_order_id)
    card_order = CardOrder.find(card_order_id)

    Set.new.tap do |queued_import_ids|
      card_order.card_printings.each do |card_printing|
        front_url = card_printing.card_printing_composition.card_front_image.public_url
        back_url = card_printing.card_printing_composition.card_back_image.public_url

        [front_url, back_url].each do |image_url|
          az_url = "https://c3.amazingmail.com/submitfile.aspx?" + 
                   "userid=#{az_user}&password=#{az_password}&" + 
                   "filetype=image&filepath=#{image_url}&folder=posto"

          open(az_url) do |az_xml|
            xml = az_xml.read

            begin 
              doc = Nokogiri::XML(xml)
              code = doc.xpath("//Code")[0].text.to_i

              if code == 102
                import_id = doc.xpath("//ImportId")[0].text
                queued_import_ids << import_id
              elsif code != 100
                raise "Bad AZ Response #{code}"
              end
            rescue Exception => e
              raise "#{e.message} XML: #{xml}"
            end
          end
        end
      end
    end.to_a
  end

  def check_if_amazing_mail_has_images(queued_import_ids)
    return unless queued_import_ids.size > 0

    raise "Don't do this until SSL works"

    ready = true

    az_uri = URI.parse("https://c3.amazingmail.com/jobstatus/Services.ashx")

    queued_import_ids.each do |queued_import_id|
      payload = <<-END
<?xml version="1.0" encoding="UTF-8"?>
<AMI:QueryJobStatus_v2 xmlns:AMI="https://c3.integrato.com">
<Authentication>
    <UserId>#{az_user}</UserId>
    <Password>#{az_password}</Password>
    </Authentication>
  <Version>2</Version>
<ImportId type="image">#{queued_import_id}</ImportId>  
</AMI:QueryJobStatus_v2>
      END

      response = Net::HTTP.post_form(az_uri, { "C3QueryWebSvcRequest" => payload })

      begin 
        xml = Nokogiri::XML(response.body)
        code = xml.xpath("//JobList//StatusCode")[0].to_i

        if code == 250 || code == 229
          raise "Got error code #{code} for #{queued_import_id}"
        elsif code != 230
          ready = false
        end
      rescue Exception => e
        raise "#{e.message} XML: #{response.body}"
      end
    end

    ready ? "ready" : "not_ready"
  end

  def submit_printing_request_to_amazing_mail(card_printing_ids)
    with_closed_tempfile do |csv_file|
      CSV.open(csv_file.path, "wb") do |csv|
        csv << %w(DMID RECORDID TOFIRST TOLAST TOADDR1 TOADDR2 TOCITY TOSTATE TOZIP FRONTPDF MSGPDF)

        card_printing_ids.each do |card_printing_id|
          card_printing = CardPrinting.find(card_printing_id)
          recipient = card_printing.recipient_user

          csv << [
            az_dmid,
            card_printing_id,
            recipient.user_profile.first_name,
            recipient.user_profile.last_name,
            recipient.recipient_address.delivery_line_1,
            recipient.recipient_address.delivery_line_2,
            recipient.recipient_address.city,
            recipient.recipient_address.state,
            recipient.recipient_address.zip,
            "posto/#{card_printing.card_printing_composition.card_front_image.filename}",
            "posto/#{card_printing.card_printing_composition.card_back_image.filename}"
          ]
        end
      end
    end

    puts "submit az request #{card_printing_ids.inspect}"
    "5884949"
  end

  def check_if_printing_request_has_been_confirmed(import_id)
    puts "check az confirmed #{import_id}"
    # "confirmed", "not_confirmed", or throw if bad state
    "confirmed"
  end
end
