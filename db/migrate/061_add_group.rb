class AddGroup < ActiveRecord::Migration
  def self.up
    create_table :groups, :options => 'DEFAULT CHARSET=utf8'  do |t|
      t.column :name, :string, :limit => 50, :null => false
      t.column :description, :string, :limit => 150, :null => false
      t.column :lock_version, :integer, :default => 0
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime, :null => false
    end
    
    add_index :groups, :name, :unique => true
  end

  def self.down
    drop_table :groups
  end
end