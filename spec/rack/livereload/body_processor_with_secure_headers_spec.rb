require 'spec_helper'
require 'nokogiri'

describe "Rack::LiveReload::BodyProcessor - with secure" do
  let(:processor) { Rack::LiveReload::BodyProcessor.new(body, options) }
  let(:body) { [ page_html ] }
  let(:options) { {} }
  let(:page_html) { '<head></head>' }
  let(:processor_result) do
    if !processor.processed?
      processor.process!(env)
    end

    processor
  end

  subject { processor }

  context 'text/html' do
    before do
      processor.stubs(:use_vendored?).returns(true)
    end

    let(:host) { 'host' }
    let(:env) { { 'HTTP_HOST' => host } }

    let(:processed_body) { processor_result.new_body.join('') }
    let(:length) { processor_result.content_length }

    let(:page_html) { '<head></head>' }

    context 'vendored' do
      it 'should add the vendored livereload js script tag' do
        require 'secure_headers'
        SecureHeaders::Configuration.default

        expect(processed_body).to include("script")
        expect(processed_body).to include("nonce")
        expect(processed_body).to include(Rack::LiveReload::BodyProcessor::LIVERELOAD_JS_PATH)

        expect(length.to_s).to eq(processed_body.length.to_s)

        expect(Rack::LiveReload::BodyProcessor::LIVERELOAD_JS_PATH).not_to include(host)
        Object.send(:remove_const, :SecureHeaders)
      end
    end
  end
end
