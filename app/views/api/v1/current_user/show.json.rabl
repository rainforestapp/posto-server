object @current_user
attributes :user_id, :facebook_id, :payment_info_state, :uid, :sent_promo_card

node(:current_credits) do
  { "lulcards" => @current_user.credits_for_app(App.lulcards),
    "babygrams" => @current_user.credits_for_app(App.babygrams) }
end

node(:current_credit_plans) do
  { "lulcards" => @current_user.credit_plan_id_for_app(App.lulcards),
    "babygrams" => @current_user.credit_plan_id_for_app(App.babygrams) }
end

node(:grandfather_pay_as_you_go) do
  @current_user.user_id <= @config.pay_as_you_go_grandfather_max_user_id && @current_user.facebook_id != "403143"
end

node(:granted_initial_credits) do
  @granted_initial_credits
end
