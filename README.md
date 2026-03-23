# Shopping List Manager 

Гем на Ruby для управления списком покупок.

##  Возможности

* Добавление товаров
* Просмотр списка
* Отметка товаров как купленных
* Удаление товаров
* Подсчёт общей стоимости



##  Установка

```
git clone "https://github.com/TimofeyBN/Shopping-list-manager.git"
cd shopping-list-manager
bundle install
```



##  Использование

### Добавить товар

```
bundle exec ruby bin/shopping add "Яблоки" --quantity 3 --price 2.5
```

### Показать список

```
bundle exec ruby bin/shopping list
```

### Отметить как купленный

```
bundle exec ruby bin/shopping buy 1
```

### Удалить товар

```
bundle exec ruby bin/shopping delete 1
```

### Итоговая стоимость

```
bundle exec ruby bin/shopping total
```


##  Пример

```cmd
 bundle exec ruby bin/shopping add "Хлеб" --quantity 1 --price 1.2
Добавлено: Хлеб

 bundle exec ruby bin/shopping list
СПИСОК ПОКУПОК:
----------------------------------------
1 | Хлеб | 1 шт | 71.2 | Не куплен
----------------------------------------
Всего товаров: 1
Общее количество: 1
К оплате: 71.2

 bundle exec ruby bin/shopping buy 1
Куплен: Хлеб

 bundle exec ruby bin/shopping total
К оплате: 71.2
```



##  Структура проекта

```
lib/
  shopping_list_manager/
    item.rb
    storage.rb
    cli.rb
bin/
  shopping
spec/
  spec_helper.rb
  item_spec.rb
  cli_spec.rb
Gemfile
LICENSE
README.md
shopping_list_manager.gemspec
```


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
