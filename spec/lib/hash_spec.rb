require 'spec_helper'

describe Hash, 'to_jsonp' do
  subject do
    { :hello => 'world' }
  end

  let(:json) { subject.to_json }

  it 'returns JSON, when not provided a callback' do
    subject.to_jsonp.should == json
  end

  it 'returns JSONP, when provided a callback' do
    subject.to_jsonp('test').should == "test(#{json});"
  end
end
