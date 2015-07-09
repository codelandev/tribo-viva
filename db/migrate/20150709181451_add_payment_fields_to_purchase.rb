class AddPaymentFieldsToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :invoice_url, :string
    add_column :purchases, :invoice_pdf, :string
    add_column :purchases, :invoice_id, :string
  end
end
