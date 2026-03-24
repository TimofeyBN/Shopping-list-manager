require "spec_helper"

RSpec.describe ShoppingListManager::CLI do
  it "работает без ошибок" do
    expect {
      described_class.run(["list"])
    }.not_to raise_error
  end
end
