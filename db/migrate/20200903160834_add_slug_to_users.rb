class AddSlugToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :slug, :string

    User.find_each(&:save!)

    change_column :users, :slug, :string, null: false
    add_index :users, :slug, unique: true
  end
end
