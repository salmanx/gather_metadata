# frozen_string_literal: true

class CreateAssertionOp < Subroutine::Op
  require 'nokogiri'
  require 'open-uri'

  string :url
  string :text

  validates :url, presence: true
  validates :text, presence: true

  outputs :status

  def perform
    if (endpoint = endpoint_accessible?)
      doc = fetch_document endpoint
      text_status = text_present?(doc) ? 'PASS' : 'FAIL'
      create_assertion_record(doc, text_status)

      output :status, text_status
    else
      output :status, 'FAIL'
    end
  end

  private

  # Check if the text exists in the document body
  def text_present?(doc)
    doc.text.include?(text)
  end

  # Create an assertion record with metadata (link and image counts)
  def create_assertion_record(doc, text_status)
    create_assertion(
      numLinks: doc.css('a').count,
      numImages: doc.css('img').count,
      status: text_status
    )
  end

  def create_assertion(metadata)
    Assertion.create!(
      url:,
      text:,
      numLinks: metadata[:numLinks],
      numImages: metadata[:numImages],
      status: metadata[:status]
    )
  end

  # Fetch the HTML document of the webpage
  def fetch_document(endpoint)
    Nokogiri::HTML(endpoint)
  end

  # Check if the site is accessible when attempting to open the URL
  def endpoint_accessible?
    https_url = url.start_with?('https://') ? url : "https://#{url}"
    URI.parse(https_url).open.read
  rescue OpenURI::HTTPError => e
    log_error("HTTP Error: #{e.message}")
    nil
  rescue SocketError => e
    log_error("Socket Error: #{e.message}")
    nil
  rescue Net::OpenTimeout => e
    log_error("Connection Timeout: #{e.message}")
    nil
  rescue StandardError => e
    log_error("Error: #{e.message}")
    nil
  end

  def log_error(message)
    Rails.logger.debug message
  end
end
