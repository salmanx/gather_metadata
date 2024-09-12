class Assertion < ApplicationRecord
  after_create :capture_snapshot

  private

  def capture_snapshot
      CaptureSnapshotJob.perform_later(self)        
  end
end
