namespace :customers do
  desc 'Create Iugu customers for existing users'
  task migrate_existing: :environment do
    User.where(iugu_customer: [nil, '']).find_each do |user|
      UserSignUpJob.perform_later(user)
    end
  end
end
