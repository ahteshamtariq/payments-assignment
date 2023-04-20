class CreateMunicipalities < ActiveRecord::Migration[7.0]
  def change
    create_table :municipalities do |t|
      t.string :name
      t.integer :price_cents
      t.belongs_to :package

      t.timestamps
    end
  end
end
