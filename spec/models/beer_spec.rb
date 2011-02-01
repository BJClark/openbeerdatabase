require "spec_helper"

describe Beer do
  it { should belong_to(:brewery) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:brewery_id) }
  it { should_not allow_mass_assignment_of(:brewery_id) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(255) }
  it { should allow_mass_assignment_of(:name) }

  it { should validate_presence_of(:description) }
  it { should ensure_length_of(:description).is_at_most(4096) }
  it { should allow_mass_assignment_of(:description) }

  it { should validate_presence_of(:abv) }
  it { should validate_numericality_of(:abv) }
  it { should allow_mass_assignment_of(:abv) }
end

describe Beer, ".paginate" do
  let(:user) { Factory(:user) }

  before do
    Beer.stubs(:paginate_without_options)
  end

  it "defaults to records with no users and the first page, with 50 per page" do
    Beer.paginate
    Beer.should have_received(:paginate_without_options).with(:page       => 1,
                                                              :per_page   => 50,
                                                              :conditions => "beers.user_id IS NULL",
                                                              :order      => "id ASC",
                                                              :include    => :brewery)
  end

  it "allows overriding of pagination parameters" do
    Beer.paginate(:page => 2, :per_page => 10)
    Beer.should have_received(:paginate_without_options).with(:page       => 2,
                                                              :per_page   => 10,
                                                              :conditions => "beers.user_id IS NULL",
                                                              :order      => "id ASC",
                                                              :include    => :brewery)
  end

  it "includes user specific records when provided with a token" do
    Beer.paginate(:token => user.token)
    Beer.should have_received(:paginate_without_options).with(:page       => 1,
                                                              :per_page   => 50,
                                                              :conditions => ["beers.user_id IS NULL OR beers.user_id = ?", user.id],
                                                              :order      => "id ASC",
                                                              :include    => :brewery)
  end
end

describe Beer, ".paginate with custom sort column and direction" do
  before do
    Beer.stubs(:paginate_without_options)
  end

  it "allows customization of both options at the same time" do
    Beer.paginate(:order => "updated_at DESC")
    Beer.should have_received(:paginate_without_options).with(:page       => 1,
                                                              :per_page   => 50,
                                                              :conditions => "beers.user_id IS NULL",
                                                              :order      => "updated_at DESC",
                                                              :include    => :brewery)
  end

  %w(id name created_at updated_at).each do |column|
    it "allows #{column} as a custom sort column" do
      Beer.paginate(:order => column)
      Beer.should have_received(:paginate_without_options).with(:page       => 1,
                                                                :per_page   => 50,
                                                                :conditions => "beers.user_id IS NULL",
                                                                :order      => "#{column} ASC",
                                                                :include    => :brewery)
    end
  end

  %w(brewery_id user_id description abv).each do |column|
    it "does not allow #{column} as a custom sort column" do
      Beer.paginate(:order => column)
      Beer.should have_received(:paginate_without_options).with(:page       => 1,
                                                                :per_page   => 50,
                                                                :conditions => "beers.user_id IS NULL",
                                                                :order      => "id ASC",
                                                                :include    => :brewery)
    end
  end

  %w(asc desc).each do |order|
    it "allows #{order} as a custom sort direction" do
      Beer.paginate(:order => "id #{order}")
      Beer.should have_received(:paginate_without_options).with(:page       => 1,
                                                                :per_page   => 50,
                                                                :conditions => "beers.user_id IS NULL",
                                                                :order      => "id #{order.upcase}",
                                                                :include    => :brewery)
    end
  end

  %w(beer `beers`.`brewer_id`).each do |order|
    it "does not allow #{order} as a custom sort direction" do
      Beer.paginate(:order => "id #{order}")
      Beer.should have_received(:paginate_without_options).with(:page       => 1,
                                                                :per_page   => 50,
                                                                :conditions => "beers.user_id IS NULL",
                                                                :order      => "id ASC",
                                                                :include    => :brewery)
    end
  end
end
