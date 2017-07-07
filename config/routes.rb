Spree::Core::Engine.routes.draw do
  get 'gestpay/callbacks/success', to: 'simple_gestpay_callbacks#success'
  get 'gestpay/callbacks/failure', to: 'simple_gestpay_callbacks#failure'
  get 'gestpay/callbacks/notify', to: 'simple_gestpay_callbacks#notify'
end
