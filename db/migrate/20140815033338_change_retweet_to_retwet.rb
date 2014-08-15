class ChangeRetweetToRetwet < ActiveRecord::Migration
  def up
    connection.execute("ALTER TABLE retweets RENAME TO retwets;")
    rename_column :retwets, :tweet_id, :twet_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end