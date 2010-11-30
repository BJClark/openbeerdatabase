class AddUrlToBrewery < ActiveRecord::Migration
  def self.up
    change_table :breweries do |t|
      t.string :url, :null => true
    end
  end

  def self.down
    change_table :breweries do |t|
      t.remove :url
    end
  end
end
