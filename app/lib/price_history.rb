# frozen_string_literal: true

class PriceHistory
  def self.call(**options)
    # Price history records including their municipality associations
    price_history = Price.includes(:municipality)
    # Apply additional filters to the query based on the given options.
    price_history = price_history.where(package: options[:package]) if options[:package].present?
    price_history = price_history.where("cast(strftime('%Y', prices.created_at) as int) = ?", options[:year]) if options[:year].present?
    price_history = price_history.where(municipalities: { name: options[:municipality] }) if options[:municipality].present?

    # Group the results by the name of the municipality and extract the price values as an array
    puts price_history.group_by { |price| price.municipality&.name }.map { |key, value| [key, value.map(&:price_cents)] }.to_h
    price_history.group_by { |price| price.municipality&.name }.map { |key, value| [key, value.map(&:price_cents)] }.to_h
  end
end
