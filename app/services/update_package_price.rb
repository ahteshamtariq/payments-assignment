# frozen_string_literal: true

class UpdatePackagePrice
  def self.call(package, new_price_cents, **options)
    Package.transaction do
      price = Price.new(package: package, price_cents: package.price_cents)
      # Check if municipality option is given or not
      if options[:municipality]
        # Add municipality to package
        municipality = package.municipalities.find_or_initialize_by(name: options[:municipality])
        municipality.price_cents = new_price_cents
        municipality.save!
        # Update price attributes
        price.municipality = municipality
        price.price_cents = municipality.price_cents
      else
        # Update the current price
        package.update!(price_cents: new_price_cents)
      end
      # Add a pricing history record
      price.save!
    end
  end
end
