# frozen_string_literal: true

class CaptureSnapshotJob < ApplicationJob
  queue_as :default

  def perform(assertion)
    CreateSnapshotOp.submit!(url: assertion.url, id: assertion.id)
  end
end
