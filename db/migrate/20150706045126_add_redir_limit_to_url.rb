class AddRedirLimitToUrl < ActiveRecord::Migration[5.0]
  def change
    add_column :urls, :redir_limit, :integer
  end
end
