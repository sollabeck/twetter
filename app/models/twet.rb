class Twet < ActiveRecord::Base
  belongs_to :user

  has_many :retwets

  validates :content, :presence => true, :length => { :minimum => 2, :maximum => 140 }
  validates :user, :presence => true

  # Gets all twets made by the users referenced by the ids passed, starting with the
  # most recent twet made.
  #
  def self.by_user_ids(*ids)
    [:flatten!, :compact!, :uniq!].each{ |meth| ids.send(meth) }
    where(
      arel_table[:user_id]
      .in(ids)
      .or(arel_table[:id].in(
        Retwet.where(:user_id => ids).map(&:twet_id)
      ))
    ).order('created_at DESC')
  end
end