# frozen_string_literal: true

puts "Removing old packages and their price histories"
Package.destroy_all

puts "Creating new packages"

Package.insert_all(
  YAML.load_file(Rails.root.join("import/packages.yaml"))
)

premium = Package.find_by!(name: "premium")
plus = Package.find_by!(name: "plus")
basic = Package.find_by!(name: "basic")

puts "Creating a price history for the packages"
prices = YAML.load_file(Rails.root.join("import/initial_price_history.yaml"))

premium.prices.insert_all(prices["premium"])
plus.prices.insert_all(prices["plus"])
basic.prices.insert_all(prices["basic"])

puts "Creating new municipalities"
municipalities = YAML.load_file(Rails.root.join("import/municipalities.yaml"))
premium.municipalities.insert_all(municipalities)
plus.municipalities.insert_all(municipalities)
basic.municipalities.insert_all(municipalities)

puts "Creating a price history for the municipalities"
premium.prices.insert_all(prices["premium"].each { |price| price['municipality_id'] = premium.municipalities[rand(0..1)].id })
plus.prices.insert_all(prices["plus"].each { |price| price['municipality_id'] = plus.municipalities[rand(0..1)].id })
basic.prices.insert_all(prices["basic"].each { |price| price['municipality_id'] = basic.municipalities[rand(0..1)].id })