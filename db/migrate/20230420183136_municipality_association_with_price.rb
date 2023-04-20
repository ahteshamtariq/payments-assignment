class MunicipalityAssociationWithPrice < ActiveRecord::Migration[7.0]
  def change
    add_column :prices, :municipality_id, :integer
  end
end
