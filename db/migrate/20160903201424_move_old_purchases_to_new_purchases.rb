class MoveOldPurchasesToNewPurchases < ActiveRecord::Migration
  class OldPurchase < ActiveRecord::Base
    belongs_to :user
    belongs_to :offer

    mount_uploader :receipt, PurchaseUploader
  end

  def self.up
    puts table_exists?('old_purchases')
    if table_exists?('old_purchases')
      ActiveRecord::Base.transaction do
        OldPurchase.includes(:offer).find_each do |old|
          puts "fazendo id #{old.id}"
          purchase = Purchase.new(user: old.user,
                                  status: (old.status == 'confirmed' ? PurchaseStatus::PAID : old.status),
                                  payment_method: 'transfer',
                                  taxes: 0.0,
                                  invoice_id: old.transaction_id,
                                  created_at: old.created_at,
                                  updated_at: old.updated_at)
          if ProducerUploader.storage == CarrierWave::Storage::File
            purchase.receipt = old.receipt.url.file
          else
            purchase.remote_receipt_url = old.receipt.url
          end
          purchase.orders.build(offer: old.offer,
                                quantity: old.amount,
                                offer_value: old.offer.value,
                                created_at: old.created_at,
                                updated_at: old.updated_at)
          purchase.save!
        end
        drop_table :old_purchases
      end
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      create_table :old_purchases do |t|
        t.references :user, index: true, foreign_key: true
        t.references :offer, index: true, foreign_key: true
        t.integer :amount, null: false, default: 0
        t.string :status, null: false, default: 'pending'

        t.timestamps null: false
        t.string :transaction_id, default: '', null: false
        t.string :receipt
      end

      # In production:
      # OldPurchase.maximum(:created_at)
      # => 2015-08-16 15:17:23 UTC
      old_dates = DateTime.parse('2015-08-16 15:17:23 UTC')
      Purchase.where('"purchases"."created_at" <= ?', old_dates).find_each do |purchase|
        old = OldPurchase.new(user: purchase.user,
                              offer: purchase.orders.first.offer,
                              amount: purchase.orders.first.quantity,
                              status: (purchase.status == 'paid' ? 'confirmed' : purchase.status),
                              transaction_id: purchase.invoice_id,
                              created_at: purchase.created_at,
                              updated_at: purchase.updated_at)
        if ProducerUploader.storage == CarrierWave::Storage::File
          old.receipt = purchase.receipt.url.file
        else
          old.receipt_url = purchase.receipt.url
        end
        purchase.destroy
      end
    end
  end
end
