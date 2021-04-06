class AddViewsToUrl < ActiveRecord::Migration[5.0]
  def up
    add_column :urls, :views, :integer
    change_column_default :urls, :views, 0
    Url.connection.execute("UPDATE urls SET views = '0' WHERE views IS NULL")
    change_column_null :urls, :views, false
    add_index :urls, :alias, unique: true
  end
  def down
    remove_column :urls, :views
    remove_index :urls, :alias
  end
end
