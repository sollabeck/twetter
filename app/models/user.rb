class User < ActiveRecord::Base
  # see: https://github.com/plataformatec/devise
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :follows
  has_many :twets
  has_many :retwets

  validates :name, :presence => true
  validates :username, :presence => true, :uniqueness => true

  # Scope method to get all users except the one passed.
  #
  def self.all_except(user)
    User.where(arel_table[:id].not_eq(user.id)).order(:name)
  end

  # Leverages Twet.by_user_ids to return all twets created by this user
  # and all users that this user follows.
  #
  def all_twets
    Twet.by_user_ids(id, *follows.map(&:following_id))
  end
end
