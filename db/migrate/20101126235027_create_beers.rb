class CreateBeers < ActiveRecord::Migration
  def self.up
    create_table :beers do |t|
      t.integer :user_id
      t.string  :name, :null => false, :limit => 255
      t.timestamps
    end

    change_table :beers do |t|
      t.index :user_id
    end
  end

  def self.down
    drop_table :beers
  end
end
