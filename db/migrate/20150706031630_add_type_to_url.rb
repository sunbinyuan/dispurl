class AddTypeToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :redir_id, :integer, null: false, default: 1
    Url.connection.execute("UPDATE urls SET redir_id = '1' WHERE redir_id IS NULL")
  end
end
