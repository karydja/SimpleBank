class CreateTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :transfers do |t|
      t.decimal :amount, precision: 17, scale: 2, null: false, default: 0.00
      t.references :source_account, foreign_key: { to_table: :accounts }
      t.references :destination_account, foreign_key: { to_table: :accounts }

      t.timestamps
    end
  end
end
