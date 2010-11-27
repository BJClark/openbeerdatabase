class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :token, :null => false, :limit => 64
      t.timestamps
    end

    change_table :users do |t|
      t.index :token, :unique => true
    end
  end

  def self.down
    drop_table :users
  end
end
