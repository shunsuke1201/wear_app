class AddNotNullConstraintToUsersColumns < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :username, false
    change_column_null :users, :height, false
    change_column_null :users, :weight, false
  end
end