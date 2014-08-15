class Retwet < ActiveRecord::Base
  belongs_to :twet
  belongs_to :user

  validates :twet, :presence => true
  validates :user, :presence => true
end