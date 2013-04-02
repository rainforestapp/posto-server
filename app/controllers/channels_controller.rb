class ChannelsController < ApplicationController
  def show
    expires_in 1.day
    render text: "<script src='//connect.facebook.net/en_US/all.js'></script>"
  end
end
