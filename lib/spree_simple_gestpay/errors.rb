module SpreeSimpleGestpay
  class ShopLoginMismatch < StandardError
    def message
      'Shop Login value is not valid.'
    end
  end
end
