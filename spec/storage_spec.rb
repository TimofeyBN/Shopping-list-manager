# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShoppingListManager::Storage do
  it 'возвращает массив' do
    expect(described_class.load).to be_a(Array)
  end
end
