require 'spec_helper'

describe Twet do
  context "associations" do
    it { should belong_to :user }
    it { should have_many :retwets }
  end

  context "factories" do
    describe "#twet" do
      subject { FactoryGirl.build(:twet) }

      it { should be_valid }
    end
  end

  context "validations" do
    it { should validate_presence_of :content }
    it "should not be valid when the length is between 2 and 140 characters" do
      t1 = Twet.new(:content => '1')
      t2 = Twet.new(:content => ':)')
      t3 = Twet.new(:content => 'fdsjklsjfksdk fd kslfsdjkd')
      t4 = Twet.new(:content => '*'*140)
      t5 = Twet.new(:content => '#'*141)

      [t1, t5].each do |t|
        t.valid?
        t.errors[:content].should be_present
      end

      [t2, t3, t4].each do |t|
        t.valid?
        t.errors[:content].should_not be_present
      end
    end

    it { should validate_presence_of :user }
  end

  describe ".by_user_ids" do
    let!(:t1) { FactoryGirl.create(:twet) }
    let!(:t2) { FactoryGirl.create(:twet) }
    let!(:t3) { FactoryGirl.create(:twet) }
    let!(:t4) { FactoryGirl.create(:twet) }
    let!(:t5) { FactoryGirl.create(:twet) }
    let!(:t6) { FactoryGirl.create(:twet) }

    it "should search by user ids" do
      Twet.by_user_ids(t1.user.id, t3.user.id).load.map(&:id).should == [t3.id, t1.id]
    end

    it "should include retwets of the users" do
      t4.retwets.create!(:user => t3.user)
      t5.retwets.create!(:user => t4.user)
      t6.retwets.create!(:user => t2.user)

      Twet.by_user_ids(t1.user.id, t3.user.id).load.map(&:id).should == [t4.id, t3.id, t1.id]
    end
  end
end