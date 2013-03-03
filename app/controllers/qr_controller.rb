class QrController < ApplicationController
  def show
    uid = params[:id][1..-1]
    type = params[:id][0]

    position = nil
    case type
    when "f"
      position = :front
    when "b" 
      position = :back
    else
      raise "Bad id #{params[:id]}"
    end

    printing = CardPrinting.where(uid: uid).first

  end
end

