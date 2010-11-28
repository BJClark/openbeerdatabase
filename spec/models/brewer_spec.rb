require 'spec_helper'

describe Brewer do
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(255) }
  it { should allow_mass_assignment_of(:name) }
end

describe Brewer, '.paginate' do
  let(:user) { Factory(:user) }

  before do
    Brewer.stubs(:paginate_without_options)
  end

  it 'defaults to records with no users and the first page, with 50 per page' do
    Brewer.paginate
    Brewer.should have_received(:paginate_without_options).with(:page       => 1,
                                                                :per_page   => 50,
                                                                :conditions => 'user_id IS NULL',
                                                                :order      => 'id ASC')
  end

  it 'allows overriding of pagination parameters' do
    Brewer.paginate(:page => 2, :per_page => 10)
    Brewer.should have_received(:paginate_without_options).with(:page       => 2,
                                                                :per_page   => 10,
                                                                :conditions => 'user_id IS NULL',
                                                                :order      => 'id ASC')
  end

  it 'includes user specific records when provided with a token' do
    Brewer.paginate(:token => user.token)
    Brewer.should have_received(:paginate_without_options).with(:page       => 1,
                                                                :per_page   => 50,
                                                                :conditions => ['user_id IS NULL OR user_id = ?', user.id],
                                                                :order      => 'id ASC')
  end

  it 'does not allow overriding order' do
    Brewer.paginate(:order => 'name DESC')
    Brewer.should have_received(:paginate_without_options).with(:page       => 1,
                                                                :per_page   => 50,
                                                                :conditions => 'user_id IS NULL',
                                                                :order      => 'id ASC')
  end
end
