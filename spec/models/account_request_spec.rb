require 'spec_helper'

describe AccountRequest do
  it { should have_many(:requested_students) }
  it { should have_one(:account_invitation) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }

  it 'destroys dependent students'

  it 'requires one associated student'

  it 'validates format of email'

  describe '#state' do

    it 'initializes to pending' do
      AccountRequest.new.state.should == 'pending'
    end
  end

  describe '.pending' do
    context 'given two account requests in pending state' do

      before(:each) do
        @account_requests = [].tap do |a|
          2.times { a << Factory(:account_request) }
        end
      end

      it 'returns those two account requests' do
        @account_requests.each do |acc_req|
          AccountRequest.pending.should include(acc_req)
        end
      end
    end
  end

  describe '.approved' do
    context 'given two account requests in approved state' do

      before(:each) do
        @account_requests = [].tap do |a|
          2.times { a << Factory(:account_request, :state => 'approved') }
        end
      end

      it 'returns those two account requests' do
        @account_requests.each do |acc_req|
          AccountRequest.approved.should include(acc_req)
        end
      end
    end
  end

  describe '#approve!' do
    context 'given a pending account request' do

      let(:account_request) { Factory(:account_request) }

      it 'sets state to approved' do
        account_request.approve!
        account_request.approved?.should be_true
      end
    end
  end
end
