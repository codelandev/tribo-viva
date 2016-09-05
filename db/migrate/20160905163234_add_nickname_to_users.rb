class AddNicknameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nickname, :string
    populate_nicknames
  end

  private

  def populate_nicknames
    ids_and_names = User.pluck(:id, :name)
    ids = ids_and_names.map(&:first)
    nicknames = ids_and_names.map do |id_and_name|
      { nickname: id_and_name.last.split(' ').first }
    end
    User.update(ids, attributes)
  end
end
