# frozen_string_literal: true

class Assertion < ApplicationRecord
  after_create :capture_snapshot

  private

  def capture_snapshot
    CreateSnapshotOp.submit!(url:, id:)
  end
end
