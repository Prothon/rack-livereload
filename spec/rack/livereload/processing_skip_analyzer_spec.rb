require 'spec_helper'

describe Rack::LiveReload::ProcessingSkipAnalyzer do
  subject { described_class.new(result, env, options) }

  let(:result) { [ status, headers, body ] }
  let(:env) { { 'HTTP_USER_AGENT' => user_agent } }
  let(:options) { {} }

  let(:user_agent) { 'Firefox' }
  let(:status) { 200 }
  let(:headers) { {} }
  let(:body) { [] }

  describe '#skip_processing?' do
    it "should skip processing" do
      expect(subject.skip_processing?).to be_truthy
    end
  end

  describe '#ignored?' do
    let(:options) { { :ignore => [ %r{file} ] } }

    context 'path contains ignore pattern' do
      let(:env) { { 'PATH_INFO' => '/this/file', 'QUERY_STRING' => '' } }

      it { is_expected.to be_ignored }
    end

    context 'root path' do
      let(:env) { { 'PATH_INFO' => '/', 'QUERY_STRING' => '' } }

      it { is_expected.not_to be_ignored }
    end
  end

  describe '#chunked?' do
    context 'regular response' do
      it { is_expected.not_to be_chunked }
    end

    context 'chunked response' do
      let(:headers) { { 'Transfer-Encoding' => 'chunked' } }

      it { is_expected.to be_chunked }
    end
  end

  describe '#inline?' do
    context 'inline disposition' do
      let(:headers) { { 'Content-Disposition' => 'inline; filename=my_inlined_file' } }

      it { is_expected.to be_inline }
    end
  end

  describe '#ignored?' do
    let(:path_info) { 'path info' }
    let(:query_string) { 'query_string' }
    let(:env) { { 'PATH_INFO' => path_info, 'QUERY_STRING' => query_string } }

    context 'no ignore set' do
      it { is_expected.not_to be_ignored }
    end

    context 'ignore set' do
      let(:options) { { :ignore => [ %r{#{path_info}} ] } }

      it { is_expected.to be_ignored }
    end

    context 'ignore set including query_string' do
      let(:options) { { :ignore => [ %r{#{path_info}\?#{query_string}} ] } }

      it { is_expected.to be_ignored }
    end
  end

  describe '#bad_browser?' do
    context 'Firefox' do
      it { is_expected.not_to be_bad_browser }
    end

    context 'BAD browser' do
      let(:user_agent) { described_class::BAD_USER_AGENTS.first.source }

      it { is_expected.to be_bad_browser }
    end
  end

  describe '#html?' do
    context 'HTML content' do
      let(:headers) { { 'Content-Type' => 'text/html' } }

      it { is_expected.to be_html }
    end

    context 'PDF content' do
      let(:headers) { { 'Content-Type' => 'application/pdf' } }

      it { is_expected.not_to be_html }
    end
  end

  describe '#get?' do
    context 'GET request' do
      let(:env) { { 'REQUEST_METHOD' => 'GET' } }

      it { is_expected.to be_get }
    end

    context 'PUT request' do
      let(:env) { { 'REQUEST_METHOD' => 'PUT' } }

      it { is_expected.not_to be_get }
    end

    context 'POST request' do
      let(:env) { { 'REQUEST_METHOD' => 'POST' } }

      it { is_expected.not_to be_get }
    end

    context 'DELETE request' do
      let(:env) { { 'REQUEST_METHOD' => 'DELETE' } }

      it { is_expected.not_to be_get }
    end

    context 'PATCH request' do
      let(:env) { { 'REQUEST_METHOD' => 'PATCH' } }

      it { is_expected.not_to be_get }
    end
  end
end

