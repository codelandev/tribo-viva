namespace :payment_migration do
  desc "Remove all duplicated users from platform"
  task remove_duplicated_users: :environment do
    duplicated = User.select(:email).group(:email).having('COUNT(email) > 1')
    printf "\n\n === Found #{duplicated.count} duplicated users ... \n\n"
    duplicated.collect(&:email).each do |email|
      original_id = User.where(email: email).pluck(:id).first
      printf "=== Removing #{email} ... \n"
      User.where(email: email).where.not(id: original_id).destroy_all
    end
    printf "\n\n... and now all gone ... \n\n"
  end

  desc "Changes all password and send password recovery to users"
  task send_massive_password_recovery: :environment do
    begin
      User.find_each do |record|
        # Assign a random password
        record.password = SecureRandom.hex
        record.save(validate: false)
        # Send change notification
        UserMailer.massive_reset_password(record).deliver_now
      end
    rescue Exception => e
      puts "Error: #{e.message}"
    end
  end
end
