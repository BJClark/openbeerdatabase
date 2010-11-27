require 'spec_helper'

describe Beer do
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(255) }
  it { should allow_mass_assignment_of(:name) }
end

describe Beer, '.search' do
  let(:user) { Factory(:user) }

  before do
    Beer.stubs(:paginate)
  end

  it 'defaults to records with no users and the first page, with 50 per page' do
    Beer.search
    Beer.should have_received(:paginate).with(:page       => 1,
                                              :per_page   => 50,
                                              :conditions => 'user_id IS NULL',
                                              :order      => 'id ASC')
  end

  it 'allows overriding of pagination parameters' do
    Beer.search(:page => 2, :per_page => 10)
    Beer.should have_received(:paginate).with(:page       => 2,
                                              :per_page   => 10,
                                              :conditions => 'user_id IS NULL',
                                              :order      => 'id ASC')
  end

  it 'includes user specific records when provided with a token' do
    Beer.search(:token => user.token)
    Beer.should have_received(:paginate).with(:page       => 1,
                                              :per_page   => 50,
                                              :conditions => ['user_id IS NULL OR user_id = ?', user.id],
                                              :order      => 'id ASC')
  end

  it 'does not allow overriding order' do
    Beer.search(:order => 'name DESC')
    Beer.should have_received(:paginate).with(:page       => 1,
                                              :per_page   => 50,
                                              :conditions => 'user_id IS NULL',
                                              :order      => 'id ASC')
  end
end

describe Beer, '#as_json' do
  subject { Factory(:beer) }

  it 'returns the id and name attributes of the beer as JSON' do
    subject.as_json.should == { :id => subject.id, :name => subject.name }
  end
end
