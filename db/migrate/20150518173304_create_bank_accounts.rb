class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :cc,             null: false, default: true
      t.string :bank,           null: false, default: true
      t.string :agency,         null: false, default: true
      t.string :bank_number,    null: false, default: true
      t.string :operation_code, null: false, default: true

      t.timestamps null: false
    end
  end
end
