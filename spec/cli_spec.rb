# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShoppingListManager::CLI do
  it 'работает без ошибок' do
    expect do
      described_class.run(['list'])
    end.not_to raise_error
  end
end
