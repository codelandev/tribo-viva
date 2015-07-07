namespace :payment_migration do
  desc "Remove all duplicated users from platform"
  task remove_duplicated_users: :environment do
    normal_ids     = User.select("MIN(id) as id").group(:email, :id).order(id: :asc).collect(&:id)
    duplicated_ids = User.where.not(id: normal_ids)
    printf "\n\n === Found #{duplicated_ids.count} duplicated users ... \n\n"
    duplicated_ids.destroy_all
    printf "... and now all gone ... \n\n"
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
