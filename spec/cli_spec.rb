# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShoppingListManager::CLI do
  it 'не падает на list' do
    expect do
      described_class.run(['list'])
    end.not_to raise_error
  end

  it 'не падает на help' do
    expect do
      described_class.run(['help'])
    end.not_to raise_error
  end
end
