# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'
require 'vcr'
require 'fileutils'

RSpec.describe CreateSnapshotOp do
  let(:url) { 'autify.com' }
  let(:id) { '123' }
  let(:operation) { described_class.new(url:, id:) }
  let(:full_url) { "https://#{url}" }
  let(:file_name) { "#{URI.parse(full_url).host.split('.').first}.#{id}.png" }
  let(:folder_path) { 'public/snapshots' }
  let(:save_path) { File.join(folder_path, file_name) }

  before do
    allow(FileUtils).to receive(:mkdir_p).with(folder_path)
    allow_any_instance_of(Puppeteer::Page).to receive(:goto)
    allow_any_instance_of(Puppeteer::Page).to receive(:screenshot)
    allow_any_instance_of(Assertion).to receive(:update)
    allow(Assertion).to receive(:find_by).with(id: id.to_i).and_return(double('Assertion', update: true))
  end

  describe '#file_name' do
    it 'generates the correct file name based on URL and ID' do
      expect(operation.send(:file_name)).to eq(file_name)
    end
  end

  describe '#ensure_https' do
    it 'prepends https:// to the URL if it does not start with https://' do
      expect(operation.send(:ensure_https)).to eq(full_url)
    end
  end
end
