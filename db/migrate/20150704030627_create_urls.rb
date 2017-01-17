class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :name
      t.string :redirect_to
      t.string :alias

      t.timestamps null: false
    end
  end
end
