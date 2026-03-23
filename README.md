# Shopping List Manager 

Простой гем на Ruby для управления списком покупок.

##  Возможности

* Добавление товаров
* Просмотр списка
* Отметка товаров как купленных
* Удаление товаров
* Подсчёт общей стоимости



##  Установка

```bash
git clone https://github.com/your-username/shopping-list-manager.git
cd shopping-list-manager
bundle install
```



##  Использование

### Добавить товар

```bash
./bin/shopping add "Яблоки" --quantity 3 --price 2.5
```

### Показать список

```bash
./bin/shopping list
```

### Отметить как купленный

```bash
./bin/shopping buy 1
```

### Удалить товар

```bash
./bin/shopping delete 1
```

### Итоговая стоимость

```bash
./bin/shopping total



##  Пример


$ ./bin/shopping add "Хлеб" --quantity 1 --price 1.2
Добавлено: Хлеб

$ ./bin/shopping list
1 | Хлеб | 1 шт | 1.2 | Не куплен

$ ./bin/shopping buy 1
Отмечено как куплено

$ ./bin/shopping total
Итого: 0




##  Структура проекта


lib/
  shopping_list_manager/
    item.rb
    storage.rb
    cli.rb
bin/
  shopping
spec/
Gemfile




##  Технологии

* Ruby
* RSpec
* JSON
* RuboCop



##  Лицензия

MIT



##  Участники

* Батраков Тимофей
* Гаджиев Арсен
