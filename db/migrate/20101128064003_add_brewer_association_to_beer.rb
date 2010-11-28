class AddBrewerAssociationToBeer < ActiveRecord::Migration
  def self.up
    change_table :beers do |t|
      t.integer :brewer_id, :null => false
    end
  end

  def self.down
    change_table :beers do |t|
      t.remove :brewer_id
    end
  end
end
