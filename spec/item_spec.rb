# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShoppingListManager::Item do
  it 'считает total' do
    item = described_class.new(id: 1, name: 'Milk', quantity: 2, price: 2)
    expect(item.total).to eq(4)
  end

  it 'проверяет одинаковые товары' do
    item = described_class.new(id: 1, name: 'Milk', quantity: 1, price: 2)

    expect(item.same?('milk', 2)).to be true
  end

  it 'добавляет количество' do
    item = described_class.new(id: 1, name: 'Milk', quantity: 1, price: 2)

    item.add_quantity(2)
    expect(item.quantity).to eq(3)
  end

  it 'выбрасывает ошибку при плохих данных' do
    expect do
      described_class.new(id: 1, name: '', quantity: 1, price: 2)
    end.to raise_error(ArgumentError)
  end

  it 'форматирует цену' do
    item = described_class.new(id: 1, name: 'Milk', quantity: 1, price: 2)
    expect(item.formatted_price).to eq('2.00')
  end

  it 'проверяет bought?' do
    item = described_class.new(id: 1, name: 'Milk', quantity: 1, price: 2)
    expect(item.bought?).to be false
  end
end
