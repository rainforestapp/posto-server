module Api
  module V1
    class PhotoUploadTokensController < ApplicationController
      def new
        s3 = AWS::S3.new
        bucket = s3.buckets[@config.card_image_bucket]
        uuid = SecureRandom.hex

        # TODO log this somewhere that this device took this token

        key = "#{uuid[0...2]}/#{uuid[2...4]}/#{uuid[4...6]}/#{uuid}.jpg"

        post = bucket.presigned_post(key: key)
                       .where(:content_length).in(1..@config.max_photo_byte_size)
                       .where(:key).is(key)
                       .where(:content_type).is("image/jpeg")
                       .where(:acl).is("public-read")

        respond_to do |format|
          format.json do
            render json: {
              url: post.url.to_s,
              fields: post.fields,
              uuid: uuid
            }
          end
        end
      end
    end
  end
end
