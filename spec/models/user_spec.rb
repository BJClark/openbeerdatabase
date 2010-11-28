require 'spec_helper'

describe User do
  subject { Factory(:user) }

  it { should have_many(:beers) }
  it { should have_many(:brewers) }

  it { should validate_presence_of(:token) }
  it { should_not allow_mass_assignment_of(:token) }
end

describe User, 'being created' do
  subject { Factory.build(:user) }

  it 'generates an API token' do
    subject.token.should be_nil
    subject.save
    subject.token.should_not be_nil
  end
end

describe User, 'being updated' do
  subject { Factory(:user) }

  let!(:token) { subject.token }

  it 'does not regenerate API token' do
    subject.updated_at = Time.now
    subject.save
    subject.token.should == token
  end
end
