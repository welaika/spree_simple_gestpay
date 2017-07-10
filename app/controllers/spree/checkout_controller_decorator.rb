Spree::CheckoutController.class_eval do
  before_action :redirect_to_gestpay, only: :update, if: proc { params[:state].eql?('payment') }

  private

  def redirect_to_gestpay
    return unless paying_with_gestpay?

    gestpay_order = create_gestpay_order(@order)

    unless gestpay_order.valid?
      raise Spree::Core::GatewayError,
            Spree.t('invalid_gestpay_order', scope: 'gestpay')
    end

    encryption_result = SimpleGestpay::WsCrypt.run!(order: gestpay_order)

    if encryption_result.failure?
      raise Spree::Core::GatewayError,
            Spree.t('encryption_error', scope: 'gestpay')
    end

    url = SimpleGestpay::PaymentPage.new(encrypted_string: encryption_result.encrypted_string).url
    redirect_to url
  end

  def create_gestpay_order(order)
    SimpleGestpay::Order.new(
      amount: order.total,
      shop_transaction_id: order.number,
      buyer_email: order.email,
      buyer_name: order.bill_address.full_name
    )
  end

  def paying_with_gestpay?
    payment_attributes = params.dig(:order, :payments_attributes)
    return false if payment_attributes.blank?

    payment_method = Spree::PaymentMethod
                     .find(payment_attributes.first[:payment_method_id])
    payment_method.is_a?(Spree::PaymentMethod::GestpayRedirect)
  end
end
