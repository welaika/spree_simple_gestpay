module Spree
  # I'm using PaymentMethod instead of Gateway as parent class
  # because we support only the simplest gestpay integration (redirect
  # to their payment page). In fact, we never need to store (even in memory)
  # credit card info.
  class PaymentMethod::GestpayRedirect < PaymentMethod
    # Even if this is true, Spree won't automatically capture
    # because source is not required (`source_required?` => false)
    def auto_capture?
      true
    end

    # We do not need credit card info, because everything
    # is processed by GestPay
    def source_required?
      false
    end

    def payment_profiles_supported?
      false
    end

    def actions
      %w[capture void]
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      %w[checkout pending].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def capture(*)
      simulated_successful_billing_response
    end

    def void(*)
      simulated_successful_billing_response
    end

    def cancel(*)
      simulated_successful_billing_response
    end

    def credit(*)
      simulated_successful_billing_response
    end

    private

    def simulated_successful_billing_response
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end
  end
end
