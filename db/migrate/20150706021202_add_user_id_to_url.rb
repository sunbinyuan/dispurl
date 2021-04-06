class AddUserIdToUrl < ActiveRecord::Migration[5.0]
  def up
    add_reference :urls, :user, index: true, foreign_key: true
  end
  def down
    remove_column :urls, :user_id
  end
end
