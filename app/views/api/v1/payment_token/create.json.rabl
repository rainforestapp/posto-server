object @stripe_customer
attributes :stripe_id
node(:payment_info_state) { |customer| customer.user.payment_info_state }
