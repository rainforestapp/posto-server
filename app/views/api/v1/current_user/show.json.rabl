object @current_user
attributes :user_id, :facebook_id, :payment_info_state

node(:current_credits) do
  { "lulcards" => @current_user.credits_for_app(App.lulcards) }
end

node(:granted_initial_credits) do
  @granted_initial_credits
end
