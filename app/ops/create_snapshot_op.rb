# frozen_string_literal: true

class CreateSnapshotOp < Subroutine::Op
  require 'fileutils'

  string :url
  string :id

  def perform
    capture_snapshot
    update_assertion
  end

  private

  def capture_snapshot
    folder_path = Rails.configuration.snapshot_folder
    FileUtils.mkdir_p(folder_path)
    save_path = File.join(folder_path, file_name)
    save_snapshot(save_path)
  end

  def save_snapshot(save_path)
    Puppeteer.launch(headless: true, args: ['--no-sandbox', '--disable-setuid-sandbox']) do |browser|
      page = browser.new_page
      dimensions = page.evaluate(<<~JAVASCRIPT)
        () => {
            return {
            width: document.documentElement.scrollWidth,
            height: document.documentElement.scrollHeight
            };
        }
      JAVASCRIPT
      page.viewport = Puppeteer::Viewport.new(width: dimensions['width'], height: dimensions['height'])
      page.goto(ensure_https, wait_until: 'domcontentloaded')
      page.screenshot(path: save_path, full_page: true)
    end
  end

  def update_assertion
    assertion = Assertion.find_by(id: id.to_i)
    return unless assertion

    assertion.update(snapshotUrl: file_name)
  end

  def file_name
    # Generate the file name based on the host and ID
    host = URI.parse(ensure_https).host.split('.').first # Get the subdomain if available
    "#{host}.#{id}.png"
  end

  def ensure_https
    url.start_with?('https://') ? url : "https://#{url}"
  end
end
