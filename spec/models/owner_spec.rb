require 'spec_helper'

describe Owner do
  context 'valid owner' do
    let(:owner) { FactoryGirl.build(:owner) }
    it('it should be valid') { owner.should be_valid }
  end
  context 'invalid owner' do
    let(:owner) { FactoryGirl.build(:owner, :email => nil) }
    it('should have an error on email') { owner.should be_invalid }
  end
end
