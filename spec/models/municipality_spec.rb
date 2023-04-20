require 'rails_helper'

RSpec.describe Municipality do
  it "validates the presence of name" do
    municipality = Municipality.new(name: nil)
    expect(municipality.validate).to eq(false)
    expect(municipality.errors[:name]).to be_present
  end

  it "validates the presence of price_cents" do
    municipality = Municipality.new(price_cents: nil)
    expect(municipality.validate).to eq(false)
    expect(municipality.errors[:price_cents]).to be_present
  end
end
