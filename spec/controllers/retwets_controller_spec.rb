require 'spec_helper'

describe RetwetsController do
  let(:twet) { FactoryGirl.create(:twet) }
  let(:retwet) { FactoryGirl.create(:retwet) }

  context "when a user is not logged in" do
    describe "POST create" do
      subject { response }

      before { post :create, :retwet => { :twet_id => twet.id } }

      it { should_not be_successful }
    end

    describe "DELETE destroy" do
      subject { response }

      before { delete :destroy, :id => retwet.id }

      it { should_not be_successful }

      it "should not delete the retwet" do
          Retwet.where(:id => retwet.id).exists?.should == 1
      end
    end
  end

  context "when a user is logged in" do
    let(:user) { FactoryGirl.create(:user) }

    before { sign_in user }

    describe "POST create" do
      context "when passed a valid twet id" do
        it "should create the retwet" do
          expect {
            post :create, :retwet => { :twet_id => twet.id }
          }.to change{ Retwet.count }.by(1)
        end

        it "should set a success notice" do
          post :create, :retwet => { :twet_id => twet.id }
          flash[:success].should == "You retweted: #{twet.content}"
        end
      end

      context "when passed an invalid twet id" do
        it "should not create the retwet" do
          expect {
            post :create, :retwet => { :twet_id => -1 }
          }.to_not change{ Retwet.count }
        end

        it "should set an error notice" do
          post :create, :retwet => { :twet_id => -1 }
          flash[:error].should == "We're sorry. You are unable to retwet that post."
        end
      end

      context "when a return_to param is provided" do
        let(:return_to) { 'http://thinkful.com' }

        subject { response }

        before { post :create, :retwet => { :twet_id => twet.id }, :return_to => return_to }

        it { should redirect_to return_to }
      end

      context "when no return_to param is provided" do
        subject { response }

        before { post :create, :retwet => { :twet_id => twet.id } }

        it { should redirect_to root_path }
      end
    end

    describe "DELETE destroy" do
      context "when passed a valid retwet id (exists / belongs to current user)" do
        let(:retwet) { FactoryGirl.create(:retwet, :user => user) }

        it "should delete the retwet" do
          delete :destroy, :id => retwet.id

          Retwet.where(:id => retwet.id).exists?.should == nil
        end
      end

      context "when passed a retwet id which does not belong to the current user" do
        it "should set an error notice" do
          delete :destroy, :id => retwet.id
          flash[:error].should == "We're sorry. We could not find that retwet."
        end
      end

      context "when passed an invalid retwet id" do
        it "should set an error notice" do
          delete :destroy, :id => -1
          flash[:error].should == "We're sorry. We could not find that retwet."
        end
      end

      context "when a return_to param is provided" do
        let(:return_to) { 'http://thinkful.com' }

        subject { response }

        before { delete :destroy, :id => retwet.id, :return_to => return_to }

        it { should redirect_to return_to }
      end

      context "when no return_to param is provided" do
        subject { response }

        before { delete :destroy, :id => retwet.id }

        it { should redirect_to root_path }
      end
    end
  end
end