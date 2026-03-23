require "json"
require_relative "item"

module ShoppingListManager
  class Storage
    FILE = "data.json"

    def self.load
      return [] unless File.exist?(FILE)

      data = JSON.parse(File.read(FILE))
      data.map { |i| Item.from_h(i) }
    end

    def self.save(items)
      File.write(FILE, JSON.pretty_generate(items.map(&:to_h)))
    end
  end
end
