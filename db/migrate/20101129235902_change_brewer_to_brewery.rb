class ChangeBrewerToBrewery < ActiveRecord::Migration
  def self.up
    rename_table :brewers, :breweries
    change_table :beers do |t|
      t.integer :brewery_id
    end

    Beer.update_all "brewery_id = brewer_id"

    change_table :beers do |t|
      t.remove :brewer_id
      t.change :brewery_id, :integer, :null => false
    end
  end

  def self.down
    rename_table :breweries, :brewers
    change_table :beers do |t|
      t.integer :brewer_id
    end

    Beer.update_all "brewer_id = brewery_id"

    change_table :beers do |t|
      t.remove :brewery_id
      t.change :brewer_id, :integer, :null => false
    end
  end
end
