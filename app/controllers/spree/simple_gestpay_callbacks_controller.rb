module Spree
  class SimpleGestpayCallbacksController < StoreController
    # Probably we do not need this skip, because all requests are GET ones
    # skip_before_action :verify_authenticity_token

    before_action :ensure_validity_of_shop_login

    rescue_from SpreeSimpleGestpay::ShopLoginMismatch do |exception|
      render text: exception.message, status: :bad_request
    end

    def notify
      transaction_result = SimpleGestpay::WsDecrypt.run!(crypted_string: encrypted_string)

      if transaction_result.failure?
        logger.tagged(%w[SpreeSimpleGestpay Notify Failure]) do
          logger.warning("Error with transaction: #{transaction_result.shop_transaction_id}")
        end
        render text: '', status: :ok
        return
      end

      order = Spree::Order.find_by!(number: transaction_result.shop_transaction_id)
      order.with_lock do
        payment = order.payments.create!(
          amount: transaction_result.amount,
          payment_method: payment_method
        )
        order.next!
        if order.complete?
          # Manually capture payment because payment method does not a `source`,
          # so Spree won't automatically capture the payment, even if `auto_capture?` is true
          payment.capture!
          # GestPay needs an HTML page with status 200
          render html: "<html><body>OK</body></html>".html_safe, status: :ok
        end
      end
    end

    def success
      flash.notice = Spree.t('order_processed_successfully')
      flash[:order_completed] = true
      session[:order_id] = nil
      redirect_to root_path
    end

    def failure
      # redirect_to checkout_state_path(order.state)
      render text: 'C\'e\' qualcosa che non va'
    end

    private

    def ensure_validity_of_shop_login
      raise SpreeSimpleGestpay::ShopLoginMismatch if shop_login != SimpleGestpay.configuration.shop_login
    end

    def shop_login
      params.require(:a)
    end

    def encrypted_string
      params.require(:b)
    end

    def payment_method
      # Simplistic way to get the payment method
      # We assume there is only one SimpleGestpay payment methods in the database
      # and even if the are more of them, we take the first
      Spree::PaymentMethod.find_by!(type: 'Spree::PaymentMethod::GestpayRedirect')
    end
  end
end
