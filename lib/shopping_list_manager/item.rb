# frozen_string_literal: true

module ShoppingListManager
  class Item
    attr_accessor :id, :name, :quantity, :price, :bought

    def initialize(id:, name:, quantity:, price:, bought: false)
      raise ArgumentError, 'Название не может быть пустым' if name.nil? || name.strip.empty?
      raise ArgumentError, 'Количество должно быть > 0' if quantity.to_i <= 0
      raise ArgumentError, 'Цена должна быть > 0' if price.to_f <= 0

      @id = id
      @name = name.strip
      @quantity = quantity.to_i
      @price = price.to_f
      @bought = bought
    end

    def total
      quantity * price
    end

    def formatted_price
      format('%.2f', price)
    end

    def formatted_total
      format('%.2f', total)
    end

    def bought?
      @bought
    end

    def mark_as_bought!
      self.bought = true
    end

    def valid?
      quantity.positive? && price.positive? && !name.to_s.strip.empty?
    end

    def same?(other_name, other_price)
      name.downcase == other_name.downcase && price == other_price
    end

    def add_quantity(amount)
      raise ArgumentError, 'Количество должно быть > 0' if amount <= 0

      self.quantity += amount
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
