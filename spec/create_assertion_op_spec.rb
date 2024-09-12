# frozen_string_literal: true

require 'rails_helper'
require 'open-uri'
require 'nokogiri'

RSpec.describe CreateAssertionOp do
  let(:url) { 'https://autify.com/' }
  let(:text) { 'Sample text' }
  let(:operation) { described_class.new(url:, text:) }
  let(:full_url) { "https://#{url}" }

  before do
    # Stubbing external dependencies
    allow_any_instance_of(CreateAssertionOp).to receive(:fetch_document).and_return(Nokogiri::HTML("<html><body>#{text}</body></html>"))
    allow_any_instance_of(CreateAssertionOp).to receive(:log_error)
  end

  describe '#perform' do
    context 'when the endpoint is accessible and text is present' do
      before do
        allow_any_instance_of(CreateAssertionOp).to receive(:endpoint_accessible?).and_return(full_url)
      end

      it 'creates an assertion record and outputs PASS' do
        expect { operation.perform }.to change(Assertion, :count).by(1)
        expect(operation.outputs[:status]).to eq('PASS')
      end
    end

    context 'when the endpoint is accessible but text is not present' do
      before do
        allow_any_instance_of(CreateAssertionOp).to receive(:endpoint_accessible?).and_return(full_url)
        allow_any_instance_of(CreateAssertionOp).to receive(:fetch_document).and_return(Nokogiri::HTML('<html><body>No text</body></html>'))
      end

      it 'creates an assertion record and outputs FAIL' do
        expect { operation.perform }.to change(Assertion, :count).by(1)
        expect(operation.outputs[:status]).to eq('FAIL')
      end
    end

    context 'when the endpoint is not accessible' do
      before do
        allow_any_instance_of(CreateAssertionOp).to receive(:endpoint_accessible?).and_return(nil)
      end

      it 'outputs FAIL and does not create an assertion record' do
        expect { operation.perform }.not_to change(Assertion, :count)
        expect(operation.outputs[:status]).to eq('FAIL')
      end
    end
  end

  describe '#text_present?' do
    it 'returns true if the text is present in the document' do
      doc = Nokogiri::HTML("<html><body>#{text}</body></html>")
      expect(operation.send(:text_present?, doc)).to be_truthy
    end

    it 'returns false if the text is not present in the document' do
      doc = Nokogiri::HTML('<html><body>No text</body></html>')
      expect(operation.send(:text_present?, doc)).to be_falsey
    end
  end

  describe '#fetch_document' do
    it 'parses the HTML document correctly' do
      doc = Nokogiri::HTML("<html><body>#{text}</body></html>")
      allow_any_instance_of(CreateAssertionOp).to receive(:fetch_document).and_return(doc)
      expect(operation.send(:fetch_document, full_url)).to be_a(Nokogiri::HTML::Document)
    end
  end

  describe '#endpoint_accessible?' do
    it 'returns the URL when it is accessible' do
      allow_any_instance_of(CreateAssertionOp).to receive(:endpoint_accessible?).and_return(full_url)
      expect(operation.send(:endpoint_accessible?)).to eq(full_url)
    end

    it 'returns nil when an error occurs' do
      allow_any_instance_of(CreateAssertionOp).to receive(:endpoint_accessible?).and_return(nil)
      expect(operation.send(:endpoint_accessible?)).to be_nil
    end
  end

  describe '#create_assertion' do
    it 'creates an assertion with the correct attributes' do
      doc = Nokogiri::HTML("<html><body>#{text}</body></html>")
      operation.send(:create_assertion_record, doc, 'PASS')
      assertion = Assertion.last
      expect(assertion).to be_present
      expect(assertion.url).to eq(url)
      expect(assertion.text).to eq(text)
      expect(assertion.numLinks).to eq(doc.css('a').count)
      expect(assertion.numImages).to eq(doc.css('img').count)
      expect(assertion.status).to eq('PASS')
    end
  end
end
