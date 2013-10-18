class DripNotifier
  def self.drip_1_day(params)
    send_drip_notification("Hey there! You still have credit to send NUMBER_OF_FREE_CARDS free ENTITY. We promise they'll love it :)", params)
  end

  def self.drip_3_day(params)
    send_drip_notification("You've still got NUMBER_OF_FREE_CARDS free ENTITY you can send. Go for it!", params)
  end

  def self.drip_1_week(params)
    send_drip_notification("Just a reminder, we still owe you NUMBER_OF_FREE_CARDS free ENTITY. You can mail it to anyone in the US!", params)
  end

  def self.drip_2_week(params)
    send_drip_notification("It's been a while, but it's not too late to send the free ENTITY we promised you. It'll be great, we promise :)", params)
  end

  private

  def self.send_drip_notification(text, params)
    user = User.find(params[:user_id])
    app = App.find(params[:app_id])
    config = CONFIG.for_app(app)

    number_of_free_cards = (user.credits_for_app(app) / config.card_credits).floor.to_i
    return false if number_of_free_cards <= 0

    text = text.gsub(/NUMBER_OF_FREE_CARDS/, number_of_free_cards == 1 ? "a" : number_of_free_cards.to_s)
    text = text.gsub(/ENTITY/, config.entity.pluralize(number_of_free_cards))

    user.send_notification(text, app: app)
    true
  end
end
