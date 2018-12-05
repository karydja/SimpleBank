class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name
      t.decimal :balance, precision: 17, scale: 2, null: false, default: 0.00

      t.timestamps
    end
  end
end
