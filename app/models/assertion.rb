# frozen_string_literal: true

class Assertion < ApplicationRecord
  after_create :capture_snapshot

  validates :url, presence: true
  validates :text, presence: true

  private

  def capture_snapshot
    CaptureSnapshotJob.perform_later(self)
  end
end
