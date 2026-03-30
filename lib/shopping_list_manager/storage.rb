# frozen_string_literal: true

require 'json'
require_relative 'item'

module ShoppingListManager
  # Класс Storage для сохранения и обработки покупки в файл .json
  class Storage
    DEFAULT_FILE = 'data.json'

    def self.load(file = DEFAULT_FILE)
      return [] unless File.exist?(file)

      data = JSON.parse(File.read(file))
      data.map { |i| Item.from_h(i) }
    rescue JSON::ParserError
      puts 'Ошибка: файл данных повреждён. Начинаем с чистого списка.'
      []
    end

    def self.save(items, file = DEFAULT_FILE)
      File.write(file, JSON.pretty_generate(items.map(&:to_h)))
    end

    def self.next_id(items)
      items.empty? ? 1 : items.map(&:id).max + 1
    end

    def self.find_by_id(items, id)
      items.find { |i| i.id == id }
    end

    def self.delete(items, id)
      item = find_by_id(items, id)
      items.delete(item) if item
      item
    end

    def self.add_or_update(items, name, quantity, price)
      existing = items.find do |i|
        i.name.downcase == name.downcase && i.price == price
      end

      if existing
        existing.quantity += quantity
        [:updated, existing]
      else
        item = Item.new(
          id: next_id(items),
          name: name,
          quantity: quantity,
          price: price
        )
        items << item
        [:created, item]
      end
    end

    def self.total_price(items)
      items.reject(&:bought?).sum(&:total)
    end

    def self.stats(items)
      {
        total_positions: items.size,
        bought_count: items.count(&:bought?),
        total_quantity: items.sum(&:quantity)
      }
    end
  end
end
