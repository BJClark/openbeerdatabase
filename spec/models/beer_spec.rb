require 'spec_helper'

describe Beer do
  it { should belong_to(:brewer) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(255) }
  it { should allow_mass_assignment_of(:name) }

  it { should validate_presence_of(:brewer_id) }
end

describe Beer, '.paginate' do
  let(:user) { Factory(:user) }

  before do
    Beer.stubs(:paginate_without_options)
  end

  it 'defaults to records with no users and the first page, with 50 per page' do
    Beer.paginate
    Beer.should have_received(:paginate_without_options).with(:page       => 1,
                                                              :per_page   => 50,
                                                              :conditions => 'user_id IS NULL',
                                                              :order      => 'id ASC')
  end

  it 'allows overriding of pagination parameters' do
    Beer.paginate(:page => 2, :per_page => 10)
    Beer.should have_received(:paginate_without_options).with(:page       => 2,
                                                              :per_page   => 10,
                                                              :conditions => 'user_id IS NULL',
                                                              :order      => 'id ASC')
  end

  it 'includes user specific records when provided with a token' do
    Beer.paginate(:token => user.token)
    Beer.should have_received(:paginate_without_options).with(:page       => 1,
                                                              :per_page   => 50,
                                                              :conditions => ['user_id IS NULL OR user_id = ?', user.id],
                                                              :order      => 'id ASC')
  end

  it 'does not allow overriding order' do
    Beer.paginate(:order => 'name DESC')
    Beer.should have_received(:paginate_without_options).with(:page       => 1,
                                                              :per_page   => 50,
                                                              :conditions => 'user_id IS NULL',
                                                              :order      => 'id ASC')
  end
end

describe Beer, '#as_json' do
  subject { Factory(:beer) }

  it 'returns the id and name attributes along with brewer information as JSON' do
    subject.as_json.should == {
      :id     => subject.id,
      :name   => subject.name,
      :brewer => {
        :id   => subject.brewer.id,
        :name => subject.brewer.name
      }
    }
  end
end
