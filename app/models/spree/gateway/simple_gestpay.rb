module Spree
  class Gateway::SimpleGestpay < Gateway
    preference :shop_login, :string

    # Even if this is true, Spree won't automatically capture
    # because source is not required (`source_required?` => false)
    def auto_capture?
      true
    end

    # Override default string value (`gateway`) so we can
    # show a partial in the checkout page
    def method_type
      'simple_gestpay'
    end

    # We do not use an existing ActiveMerchant provider
    # so we define this class as the provider itself
    def provider_class
      provider.class
    end

    # We do not use an existing ActiveMerchange provider
    # so we define this instance as the provider itself
    def provider
      self
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
