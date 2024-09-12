# frozen_string_literal: true

class AssertionBlueprint < Blueprinter::Base
  fields :url, :text, :status, :numImages, :numLinks, :created_at

  field :snapshotUrl do |assertion|
    Rails.application.routes.url_helpers.snapshots_url(assertion.id) if assertion.snapshotUrl.present?
  end
end
