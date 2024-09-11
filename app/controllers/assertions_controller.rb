# frozen_string_literal: true

class AssertionsController < ApplicationController
  def index
    assertions = Assertion.order(created_at: :desc)

    render json: AssertionBlueprint.render(assertions)
  end

  def create
    op = CreateAssertionOp.new(assertion_params)

    if op.submit!
      render json: op.outputs, status: :created, location: @assertion
    else
      render json: op.errors, status: :unprocessable_entity
    end
  end

  private

  def assertion_params
    params.require(:assertion).permit(:url, :text)
  end
end
