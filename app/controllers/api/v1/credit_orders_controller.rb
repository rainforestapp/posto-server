module Api
  module V1
    class CreditOrdersController < ApplicationController
      include ApiSecureEndpoint

      respond_to :json

      def create
        package = params[:package]
        app = params[:app]

        return head :bad_request unless package && app

        app = App.by_name(app)

        return head :bad_request unless app

        config_package = @config.credit_packages.find do |p| 
          p[:credit_package_id] == package[:credit_package_id].to_i
        end

        return head :bad_request unless config_package

        [:credits, :price].each do |k|
          return head :bad_request if package[k].to_i != config_package[k]
        end

        stripe_customer = @current_user.stripe_customer
        return head :bad_request unless stripe_customer
        customer = Stripe::Customer.retrieve(stripe_customer.stripe_id)
        return head :bad_request unless customer
        return head :bad_request unless customer["active_card"]

        charge = nil

        begin
          charge = Stripe::Charge.create(
            amount: config_package[:price],
            currency: "usd",
            customer: customer["id"],
            description: "Charge #{config_package[:credits]} Credits"
          )
        rescue Stripe::CardError => e
          begin
            stripe_customer.stripe_customer_card.mark_as_declined!
            stripe_customer.stripe_customer_card.append_to_metadata!(message: e.message)
          rescue Exception => ex
          end

          Airbrake.notify_or_ignore(e, parameters: params)

          return head :bad_request
        end

        if charge["failure_message"]
          if stripe_customer && stripe_customer.stripe_card
            begin
              stripe_customer.stripe_customer_card.mark_as_declined!
              stripe_customer.stripe_customer_card.append_to_metadata!(message: e.message)
            rescue Exception => e
            end
          end

          return head :bad_request
        end

        begin
          CreditOrder.transaction_with_retry do
            credit_order = @current_user.credit_orders.create!(app_id: app.app_id,
                                                               credits: config_package[:credits],
                                                               price: config_package[:price])

            @current_user.add_credits!(config_package[:credits],
                                       app: app,
                                       source_type: :credit_order,
                                       source_id: credit_order.credit_order_id)
          end
        rescue Exception => e
          charge.refund rescue nil
          return head :bad_request
        end

        render json: config_package
      end
    end
  end
end
