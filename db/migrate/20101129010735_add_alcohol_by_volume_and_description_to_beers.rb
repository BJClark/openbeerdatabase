class AddAlcoholByVolumeAndDescriptionToBeers < ActiveRecord::Migration
  def self.up
    change_table :beers do |t|
      t.float :abv,         :null => false
      t.text  :description, :null => false
    end
  end

  def self.down
    change_table :beers do |t|
      t.remove :abv
      t.remove :description
    end
  end
end
