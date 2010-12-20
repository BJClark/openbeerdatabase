require 'spec_helper'

describe Brewery do
  it { should have_many(:beers) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(255) }
  it { should allow_mass_assignment_of(:name) }

  it { should ensure_length_of(:url).is_at_most(255) }
  it { should allow_mass_assignment_of(:url) }
end

describe Brewery, 'url' do
  it 'allows valid URLs' do
    [ nil,
      'http://example.com',
      'http://example.com/',
      'http://www.example.com/',
      'http://sub.domain.example.com/',
      'http://bbc.co.uk',
      'http://example.com?foo',
      'http://example.com?url=http://example.com',
      'http://www.sub.example.com/page.html?foo=bar&baz=%23#anchor',
      'http://example.com/~user',
      'http://example.xy',
      'http://example.museum',
      'HttP://example.com',
      'https://example.com',
      'http://example.com.',
      'http://example.com./foo'
    ].each do |url|
      Factory.build(:brewery, :url => url).should be_valid
    end
  end

  it 'disallows invalid URLs' do
   [ 1,
     '',
     ' ',
     'url',
     'www.example.com',
     'http://ex ample.com',
     'http://example.com/foo bar',
     'http://256.0.0.1',
     'http://u:u:u@example.com',
     'http://r?ksmorgas.com',
     'http://example',
     'http://example.c',
     'http://example.toolongtld'
    ].each do |url|
      Factory.build(:brewery, :url => url).should_not be_valid
    end
  end
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
end

describe Brewery, '.paginate with custom sort column and direction' do
  before do
    Brewery.stubs(:paginate_without_options)
  end

  it 'allows customization of both options at the same time' do
    Brewery.paginate(:order => 'updated_at DESC')
    Brewery.should have_received(:paginate_without_options).with(:page       => 1,
                                                                 :per_page   => 50,
                                                                 :conditions => 'user_id IS NULL',
                                                                 :order      => "updated_at DESC")
  end

  %w(id name created_at updated_at).each do |column|
    it "allows #{column} as a custom sort column" do
      Brewery.paginate(:order => column)
      Brewery.should have_received(:paginate_without_options).with(:page       => 1,
                                                                   :per_page   => 50,
                                                                   :conditions => 'user_id IS NULL',
                                                                   :order      => "#{column} ASC")
    end
  end

  %w(user_id).each do |column|
    it "does not allow #{column} as a custom sort column" do
      Brewery.paginate(:order => column)
      Brewery.should have_received(:paginate_without_options).with(:page       => 1,
                                                                   :per_page   => 50,
                                                                   :conditions => 'user_id IS NULL',
                                                                   :order      => "id ASC")
    end
  end

  %w(asc desc).each do |order|
    it "allows #{order} as a custom sort direction" do
      Brewery.paginate(:order => "id #{order}")
      Brewery.should have_received(:paginate_without_options).with(:page       => 1,
                                                                   :per_page   => 50,
                                                                   :conditions => 'user_id IS NULL',
                                                                   :order      => "id #{order.upcase}")
    end
  end

  %w(brewery `breweries`.`id`).each do |order|
    it "does not allow #{order} as a custom sort direction" do
      Brewery.paginate(:order => "id #{order}")
      Brewery.should have_received(:paginate_without_options).with(:page       => 1,
                                                                   :per_page   => 50,
                                                                   :conditions => 'user_id IS NULL',
                                                                   :order      => "id ASC")
    end
  end
end
