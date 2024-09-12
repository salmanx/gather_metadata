# frozen_string_literal: true

class AssertionsController < ApplicationController
  before_action :set_assertion, only: %i[fetch_snapshot]

  def index
    assertions = Assertion.order(created_at: :desc)

    render json: AssertionBlueprint.render(assertions)
  end

  def create
    op = CreateAssertionOp.new(assertion_params)

    if op.submit
      render json: op.outputs, status: :created, location: @assertion
    else
      render json: { error: op.errors }, status: :unprocessable_entity
    end
  end

  def fetch_snapshot
    snapshot_path = Rails.root.join(Rails.configuration.snapshot_folder, @assertion.snapshotUrl)

    if File.exist?(snapshot_path)
      send_file snapshot_path, type: 'image/png', disposition: 'inline'
    else
      render json: { error: 'Snapshot not found' }, status: :not_found
    end
  end

  private

  def set_assertion
    @assertion = Assertion.find_by(id: params[:id])
    return if @assertion

    render json: { error: 'Assertion not found' }, status: :not_found
  end

  def assertion_params
    params.require(:assertion).permit(:url, :text)
  end
end
