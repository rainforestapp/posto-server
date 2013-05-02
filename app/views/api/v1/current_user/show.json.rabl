object @current_user
attributes :user_id, :facebook_id, :payment_info_state, :uid

node(:current_credits) do
  { "lulcards" => @current_user.credits_for_app(App.lulcards),
    "babygrams" => @current_user.credits_for_app(App.babygrams) }
end

node(:granted_initial_credits) do
  @granted_initial_credits
end
