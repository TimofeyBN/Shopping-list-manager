require_relative "item"
require_relative "storage"
require_relative "version"

module ShoppingListManager
  class CLI
    COMMANDS = %w[add list buy delete total help].freeze

    def self.run(args)
      items = Storage.load
      command = args.shift

      case command
      when "add"
        name = args[0]

        unless name
          puts "Ошибка: укажите название товара"
          puts "Использование: shopping add <название> --quantity <кол-во> --price <цена>"
          return
        end

        quantity_str = extract_arg(args, "--quantity")
        price_str    = extract_arg(args, "--price")

        unless quantity_str && price_str
          puts "Ошибка: нужно указать --quantity и --price"
          puts "Использование: shopping add <название> --quantity <кол-во> --price <цена>"
          return
        end

        unless quantity_str =~ /\A\d+\z/
          puts "Ошибка: --quantity должно быть целым числом"
          return
        end

        unless price_str =~ /\A\d+(\.\d+)?\z/
          puts "Ошибка: --price должно быть числом (например, 1.99)"
          return
        end

        quantity = quantity_str.to_i
        price    = price_str.to_f

        if quantity <= 0
          puts "Ошибка: количество должно быть больше 0"
          return
        end

        if price <= 0
          puts "Ошибка: цена должна быть больше 0"
          return
        end

        existing = items.find do |i|
          i.name.downcase == name.downcase && i.price == price
        end

        if existing
          existing.quantity += quantity
          puts "Обновлено: #{existing.name}, новое количество: #{existing.quantity}"
        else
          id = items.empty? ? 1 : items.map(&:id).max + 1

          items << Item.new(
            id: id,
            name: name,
            quantity: quantity,
            price: price
          )

          puts "Добавлено: #{name}"
        end


      when "list"
        if items.empty?
          puts "Список покупок пуст. Добавьте товары командой: shopping add <название> --quantity <кол-во> --price <цена>"
          return
        end

        puts "\nСПИСОК ПОКУПОК:"
        puts "-" * 50

        items.each do |i|
          status = i.bought ? "✓ Куплен" : "  Не куплен"
          puts "#{i.id} | #{i.name} | #{i.quantity} шт | #{i.formatted_price} руб | #{status}"
        end

        total_items   = items.sum(&:quantity)
        total_price   = items.reject(&:bought).sum(&:total)
        bought_count  = items.count(&:bought)

        puts "-" * 50
        puts "Всего позиций: #{items.size} (куплено: #{bought_count})"
        puts "Общее количество: #{total_items} шт"
        puts "К оплате: #{"%.2f" % total_price} руб"
        puts


      when "buy"
        unless args[0]
          puts "Ошибка: укажите ID товара"
          puts "Использование: shopping buy <id>"
          return
        end

        id   = args[0].to_i
        item = items.find { |i| i.id == id }

        if item
          if item.bought
            puts "Товар «#{item.name}» уже отмечен как купленный"
          else
            item.bought = true
            puts "Куплен: #{item.name}"
          end
        else
          puts "Товар с ID #{id} не найден. Проверьте список: shopping list"
        end


      when "delete"
        unless args[0]
          puts "Ошибка: укажите ID товара"
          puts "Использование: shopping delete <id>"
          return
        end

        id   = args[0].to_i
        item = items.find { |i| i.id == id }

        if item
          items.delete(item)
          puts "Удалено: #{item.name}"
        else
          puts "Товар с ID #{id} не найден. Проверьте список: shopping list"
        end


      when "total"
        if items.empty?
          puts "Список пуст"
          return
        end

        unpaid = items.reject(&:bought)
        sum    = unpaid.sum(&:total)

        puts "К оплате: #{"%.2f" % sum} руб (#{unpaid.size} из #{items.size} позиций)"


      when "help", nil
        print_help


      else
        puts "Неизвестная команда: «#{command}»"
        print_help
      end

      Storage.save(items)
    end


    private

    def self.extract_arg(args, flag)
      index = args.index(flag)
      return nil unless index

      value = args[index + 1]
      # Убеждаемся, что значение не является другим флагом
      return nil if value.nil? || value.start_with?("--")

      value
    end

    def self.print_help
      puts <<~HELP

        Менеджер списка покупок v#{ShoppingListManager::VERSION}

        Использование:
          shopping <команда> [аргументы]

        Команды:
          add <название> --quantity <кол-во> --price <цена>   Добавить товар
          list                                                 Показать список
          buy <id>                                             Отметить как купленный
          delete <id>                                          Удалить товар
          total                                                Итоговая стоимость
          help                                                 Показать эту справку

        Примеры:
          shopping add "Молоко" --quantity 2 --price 89.90
          shopping list
          shopping buy 1
          shopping delete 3

      HELP
    end
  end
end
