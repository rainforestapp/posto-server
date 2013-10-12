class AdminMailer < ActionMailer::Base
  default from: "lulcards admin <orders@lulcards.com>"

  def email_errors(subject, body)
    @body = body

    mail(to: CONFIG.admin_error_email,
         subject: "[POSTO ERRORS] #{subject}")
  end

  def daily_flash
    get_sql_value = lambda do |sql|
      User.connection.execute(sql).first[0]
    end

    to_price = lambda do |d|
      "$%.02f" % (d / 100.0) 
    end

    subject = "[POSTO] Daily Flash for #{Time.now.strftime("%B %d, %Y")}"

    last_24_where = "> DATE_SUB(now(), interval 24 hour)"
    yesterday_where = "BETWEEN '#{1.day.ago.strftime("%Y-%m-%d")} 00:00:00' AND '#{Time.now.strftime("%Y-%m-%d")} 00:00:00'"

    # Last 24 hours completed and failed orders
    @completed_order_count = get_sql_value.call("select count(distinct card_order_id) from card_order_states where latest = 1 and state = 'finished' and created_at #{last_24_where}")
    @failed_order_count = get_sql_value.call("select count(distinct card_order_id) from card_order_states where latest = 1 and state = 'failed' and created_at #{last_24_where}")

    # Yesterday
    # State checks ok unless default state, which yields no row.
    @new_order_count = get_sql_value.call("select count(card_order_id) from card_orders where (is_promo is null or is_promo = 0) and created_at #{yesterday_where} and order_sender_user_id != 11")
    @promo_count = get_sql_value.call("select count(card_order_id) from card_orders where is_promo = 1 and created_at #{yesterday_where} and order_sender_user_id != 11")
    @new_user_count = get_sql_value.call("select count(user_id) from users where created_at #{yesterday_where}")
    @pay_as_you_go_count = get_sql_value.call("select count(distinct card_order_id) from transactions where created_at #{yesterday_where}")
    @pay_as_you_go_sum = to_price.call(get_sql_value.call("select coalesce(sum(price_units), 0) from transaction_line_items where created_at #{yesterday_where}"))
    @credit_order_count = get_sql_value.call("select count(credit_order_id) from credit_orders where created_at #{yesterday_where} and user_id != 11")
    @credit_order_sum = to_price.call(get_sql_value.call("select coalesce(sum(price), 0) from credit_orders where created_at #{yesterday_where} and user_id != 11"))
    @credit_plan_count = get_sql_value.call("select count(distinct credit_plan_membership_id) from credit_plan_memberships a where not exists (select * from credit_plan_membership_states where credit_plan_membership_id = a.credit_plan_membership_id and state = 'cancelled' and latest = 1) and user_id != 11 and created_at #{yesterday_where}")
    
    # Totals
    @total_connected_user_count = get_sql_value.call("select count(distinct user_id) from user_profiles where email is not null")
    @total_order_count = get_sql_value.call("select count(card_order_id) from card_orders where is_promo is null or is_promo = 0 and order_sender_user_id != 11")
    @total_promo_count = get_sql_value.call("select count(card_order_id) from card_orders where is_promo = 1 and order_sender_user_id != 11")
    @total_postcard_count = get_sql_value.call("select count(card_printing_id) from card_printings where card_order_id in (select card_order_id from card_orders where order_sender_user_id != 11)")
    @total_subscriber_count = get_sql_value.call("select count(distinct user_id) from credit_plan_memberships a where not exists (select * from credit_plan_membership_states where credit_plan_membership_id = a.credit_plan_membership_id and state = 'cancelled' and latest = 1) and user_id != 11")
    @total_cancelled_subscriber_count = get_sql_value.call("select count(distinct user_id) from credit_plan_memberships a where exists (select * from credit_plan_membership_states where credit_plan_membership_id = a.credit_plan_membership_id and state = 'cancelled' and latest = 1) and user_id != 11")
    @total_monthly_subscriber_revenue = to_price.call(get_sql_value.call("select coalesce(sum(credit_plan_price),0) from credit_plan_memberships a where not exists (select * from credit_plan_membership_states where credit_plan_membership_id = a.credit_plan_membership_id and state = 'cancelled' and latest = 1) and user_id != 11"))
    @total_paying_customers = get_sql_value.call("select count(distinct user_id) from stripe_customers")
    @total_people_with_addresses = get_sql_value.call("select count(distinct recipient_user_id) from recipient_addresses where address_api_response_id is not null")

    mail(to: CONFIG.admin_error_email, subject: subject)
  end
end
