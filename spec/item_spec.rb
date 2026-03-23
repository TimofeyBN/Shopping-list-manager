require "spec_helper"

RSpec.describe ShoppingListManager::Item do
  it "считает total" do
    item = described_class.new(id: 1, name: "Milk", quantity: 2, price: 2)
    expect(item.total).to eq(4)
  end
end
