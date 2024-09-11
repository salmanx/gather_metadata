# frozen_string_literal: true

class AssertionBlueprint < Blueprinter::Base
  fields :url, :text, :status, :numImages, :numLinks, :snapshotUrl, :created_at
end
