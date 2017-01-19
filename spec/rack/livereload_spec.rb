require 'spec_helper'
require 'nokogiri'

describe Rack::LiveReload do
  let(:middleware) { described_class.new(app, options) }
  let(:app) { stub }

  subject { middleware }

  it 'should be an app' do
    expect(middleware.app).to eq(app)
  end

  let(:env) { {} }
  let(:options) { {} }

  context '/__rack/livereload.js' do
    let(:env) { { 'PATH_INFO' => described_class::BodyProcessor::LIVERELOAD_JS_PATH } }

    before do
      middleware.expects(:deliver_file).returns(true)
    end

    it 'should return the js file' do
      expect(middleware._call(env)).to be_truthy
    end
  end
end

