# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShoppingListManager::Storage do
  let(:items) { [] }

  it 'добавляет новый товар' do
    result, item = described_class.add_or_update(items, 'Milk', 2, 1.5)

    expect(result).to eq(:created)
    expect(items.size).to eq(1)
    expect(item.name).to eq('Milk')
  end

  it 'обновляет существующий товар' do
    described_class.add_or_update(items, 'Milk', 2, 1.5)
    result, item = described_class.add_or_update(items, 'Milk', 3, 1.5)

    expect(result).to eq(:updated)
    expect(item.quantity).to eq(5)
  end

  it 'находит по id' do
    _, item = described_class.add_or_update(items, 'Milk', 2, 1.5)

    found = described_class.find_by_id(items, item.id)
    expect(found).to eq(item)
  end

  it 'удаляет товар' do
    _, item = described_class.add_or_update(items, 'Milk', 2, 1.5)

    deleted = described_class.delete(items, item.id)

    expect(deleted).to eq(item)
    expect(items).to be_empty
  end

  it 'считает total_price' do
    described_class.add_or_update(items, 'Milk', 2, 2)
    described_class.add_or_update(items, 'Bread', 1, 3)

    expect(described_class.total_price(items)).to eq(7)
  end

  it 'считает stats' do
    described_class.add_or_update(items, 'Milk', 2, 2)
    described_class.add_or_update(items, 'Bread', 1, 3)

    stats = described_class.stats(items)

    expect(stats[:total_positions]).to eq(2)
    expect(stats[:total_quantity]).to eq(3)
    expect(stats[:bought_count]).to eq(0)
  end

  describe '.load и .save с кастомным файлом' do
    let(:file) { 'test_data.json' }
    after { FileUtils.rm_f(file) }

    it 'сохраняет и загружает данные из указанного файла' do
      items = []
      described_class.add_or_update(items, 'Milk', 2, 1.5)
      described_class.save(items, file)

      loaded_items = described_class.load(file)
      expect(loaded_items.size).to eq(1)
      expect(loaded_items.first.name).to eq('Milk')
    end
  end
end
