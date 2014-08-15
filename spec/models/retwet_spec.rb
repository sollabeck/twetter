require 'spec_helper'

describe Retwet do
  context "associations" do
    it { should belong_to :twet }
    it { should belong_to :user }
  end

  context "factories" do
    describe "#retwet" do
      subject { FactoryGirl.build(:retwet) }

      it { should be_valid }
    end
  end

  context "validations" do
    it { should validate_presence_of :twet }
    it { should validate_presence_of :user }
  end
end