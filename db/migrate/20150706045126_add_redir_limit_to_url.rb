class AddRedirLimitToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :redir_limit, :integer
  end
end
