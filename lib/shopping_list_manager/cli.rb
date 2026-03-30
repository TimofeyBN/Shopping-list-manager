# frozen_string_literal: true

require_relative 'item'
require_relative 'storage'
require_relative 'version'

module ShoppingListManager
  class CLI
    COMMANDS = %w[add list buy delete total help].freeze

    def self.run(args)
      items = Storage.load
      command = args.shift

      case command
      when 'add'
        handle_add(items, args)

      when 'list'
        handle_list(items)

      when 'buy'
        handle_buy(items, args)

      when 'delete'
        handle_delete(items, args)

      when 'total'
        handle_total(items)

      when 'help', nil
        print_help

      else
        puts "Неизвестная команда: «#{command}»"
        print_help
      end

      Storage.save(items)
    end

    def self.extract_arg(args, flag)
      index = args.index(flag)
      return nil unless index

      value = args[index + 1]
      # Убеждаемся, что значение не является другим флагом
      return nil if value.nil? || value.start_with?('--')

      value
    end

    def self.handle_add(items, args)
      name = args[0]

      unless name
        puts 'Ошибка: укажите название товара'
        return
      end

      quantity_str = extract_arg(args, '--quantity')
      price_str    = extract_arg(args, '--price')

      unless quantity_str && price_str
        puts 'Ошибка: нужно указать --quantity и --price'
        return
      end

      unless quantity_str =~ /\A\d+\z/
        puts 'Ошибка: --quantity должно быть числом'
        return
      end

      unless price_str =~ /\A\d+(\.\d+)?\z/
        puts 'Ошибка: --price должно быть числом'
        return
      end

      quantity = quantity_str.to_i
      price    = price_str.to_f

      if quantity <= 0 || price <= 0
        puts 'Ошибка: значения должны быть больше 0'
        return
      end

      result, item = Storage.add_or_update(items, name, quantity, price)

      if result == :updated
        puts "Обновлено: #{item.name}, новое количество: #{item.quantity}"
      else
        puts "Добавлено: #{item.name}"
      end
    end

    def self.handle_list(items)
      if items.empty?
        puts 'Список пуст'
        return
      end

      puts "\nСПИСОК ПОКУПОК:"
      puts '-' * 50

      items.each do |i|
        status = i.bought? ? '✓ Куплен' : '  Не куплен'
        puts "#{i.id} | #{i.name} | #{i.quantity} шт | #{i.formatted_price} руб | #{status}"
      end

      stats = Storage.stats(items)
      total = Storage.total_price(items)

      puts '-' * 50
      puts "Всего позиций: #{stats[:total_positions]} (куплено: #{stats[:bought_count]})"
      puts "Общее количество: #{stats[:total_quantity]} шт"
      puts "К оплате: #{format('%.2f', total)} руб"
      puts
    end

    def self.handle_buy(items, args)
      id = args[0]&.to_i

      unless id
        puts 'Ошибка: укажите ID'
        return
      end

      item = Storage.find_by_id(items, id)

      unless item
        puts "Товар с ID #{id} не найден"
        return
      end

      if item.bought?
        puts "Товар «#{item.name}» уже куплен"
      else
        item.bought = true
        puts "Куплен: #{item.name}"
      end
    end

    def self.handle_delete(items, args)
      id = args[0]&.to_i

      unless id
        puts 'Ошибка: укажите ID'
        return
      end

      deleted = Storage.delete(items, id)

      if deleted
        puts "Удалено: #{deleted.name}"
      else
        puts "Товар с ID #{id} не найден"
      end
    end

    def self.handle_total(items)
      if items.empty?
        puts 'Список пуст'
        return
      end

      sum = Storage.total_price(items)

      puts "К оплате: #{format('%.2f', sum)} руб"
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

    def self.extract_arg(args, flag)
      index = args.index(flag)
      return nil unless index

      value = args[index + 1]
      return nil if value.nil? || value.start_with?('--')

      value
    end
  end
end
