# frozen_string_literal: true

module ShoppingListManager
  class Item
    attr_accessor :id, :name, :quantity, :price, :bought

    def initialize(id:, name:, quantity:, price:, bought: false)
      @id = id
      @name = name
      @quantity = quantity
      @price = price
      @bought = bought
    end

    def total
      quantity * price
    end

    def formatted_price
      '%.2f' % price
    end

    def formatted_total
      '%.2f' % total
    end

    def to_h
      {
        id: id,
        name: name,
        quantity: quantity,
        price: price,
        bought: bought
      }
    end

    def self.from_h(h)
      new(
        id: h['id'],
        name: h['name'],
        quantity: h['quantity'],
        price: h['price'],
        bought: h['bought']
      )
    end
  end
end
