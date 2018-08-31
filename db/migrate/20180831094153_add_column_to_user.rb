class AddColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :theme, :string
  end
end
