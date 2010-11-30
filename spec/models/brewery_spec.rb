require 'spec_helper'

describe Brewery do
  it { should have_many(:beers) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(255) }
  it { should allow_mass_assignment_of(:name) }
end

describe Brewery, '.paginate' do
  let(:user) { Factory(:user) }

  before do
    Brewery.stubs(:paginate_without_options)
  end

  it 'defaults to records with no users and the first page, with 50 per page' do
    Brewery.paginate
    Brewery.should have_received(:paginate_without_options).with(:page       => 1,
                                                                 :per_page   => 50,
                                                                 :conditions => 'user_id IS NULL',
                                                                 :order      => 'id ASC')
  end

  it 'allows overriding of pagination parameters' do
    Brewery.paginate(:page => 2, :per_page => 10)
    Brewery.should have_received(:paginate_without_options).with(:page       => 2,
                                                                 :per_page   => 10,
                                                                 :conditions => 'user_id IS NULL',
                                                                 :order      => 'id ASC')
  end

  it 'includes user specific records when provided with a token' do
    Brewery.paginate(:token => user.token)
    Brewery.should have_received(:paginate_without_options).with(:page       => 1,
                                                                 :per_page   => 50,
                                                                 :conditions => ['user_id IS NULL OR user_id = ?', user.id],
                                                                 :order      => 'id ASC')
  end

  it 'does not allow overriding order' do
    Brewery.paginate(:order => 'name DESC')
    Brewery.should have_received(:paginate_without_options).with(:page       => 1,
                                                                 :per_page   => 50,
                                                                 :conditions => 'user_id IS NULL',
                                                                 :order      => 'id ASC')
  end
end
