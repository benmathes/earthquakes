class CreateEarthquakes < ActiveRecord::Migration
  def change
    create_table :earthquakes do |t|
      t.string :src
      t.string :eqid
      t.integer :version
      t.datetime :datetime
      t.float :lat
      t.float :lon
      t.float :magnitude
      t.float :depth
      t.integer :nst
      t.string :region

      t.timestamps
    end
  end
end
