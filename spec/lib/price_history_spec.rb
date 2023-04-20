# frozen_string_literal: true

require "spec_helper"

RSpec.describe PriceHistory do
  # These tests cover feature request 2. Feel free to add more tests or change
  # the existing ones.

  it "returns the pricing history for the provided year and package" do
    basic = Package.create!(name: "basic")

    travel_to Time.zone.local(2019) do
      # These should NOT be included
      UpdatePackagePrice.call(basic, 20_00, municipality: "Stockholm")
      UpdatePackagePrice.call(basic, 30_00, municipality: "Göteborg")
    end

    travel_to Time.zone.local(2020) do
      UpdatePackagePrice.call(basic, 30_00, municipality: "Stockholm")
      UpdatePackagePrice.call(basic, 40_00, municipality: "Stockholm")
      UpdatePackagePrice.call(basic, 100_00, municipality: "Göteborg")
    end

    history = PriceHistory.call(package: basic, year: "2020")
    expect(history).to eq(
                         "Göteborg" => [100_00],
                         "Stockholm" => [30_00, 40_00],
                       )
  end

  context "supports filtering" do
    before do
      basic = Package.create!(name: "basic")

      travel_to Time.zone.local(2019) do
        # These should NOT be included
        UpdatePackagePrice.call(basic, 20_00, municipality: "Stockholm")
        UpdatePackagePrice.call(basic, 30_00, municipality: "Göteborg")
      end

      travel_to Time.zone.local(2020) do
        UpdatePackagePrice.call(basic, 30_00, municipality: "Stockholm")
        UpdatePackagePrice.call(basic, 40_00, municipality: "Stockholm")
        UpdatePackagePrice.call(basic, 100_00, municipality: "Göteborg")
        plus = Package.create!(name: 'plus', price_cents: 100_00)
        UpdatePackagePrice.call(plus, 200_00)
      end
    end

    it 'returns the pricing history for the provided year' do
      history = PriceHistory.call(year: "2020")
      expect(history).to eq(
                           nil => [100_00],
                           "Stockholm" => [30_00, 40_00],
                           "Göteborg" => [100_00]
                         )
    end

    it 'returns the pricing history for the provided package' do
      history = PriceHistory.call(package: Package.find_by_name('basic'))
      expect(history).to eq(
                           "Stockholm" => [20_00, 30_00, 40_00],
                           "Göteborg" => [30_00, 100_00]
                         )
    end

    it 'returns the pricing history for the provided municipality' do
      history = PriceHistory.call(municipality: 'Stockholm')
      expect(history).to eq("Stockholm" => [20_00, 30_00, 40_00])
    end

    it 'returns the pricing history for the provided year, package and municipality' do
      history = PriceHistory.call(package: Package.find_by_name('basic'), year: "2020", municipality: 'Stockholm')
      expect(history).to eq("Stockholm" => [30_00, 40_00])
    end
  end
end
