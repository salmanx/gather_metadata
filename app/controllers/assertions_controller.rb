# frozen_string_literal: true

class AssertionsController < ApplicationController
  before_action :set_assertion, only: %i[show update destroy]

  # GET /assertions
  def index
    @assertions = Assertion.all

    render json: @assertions
  end

  # GET /assertions/1
  def show
    render json: @assertion
  end

  # POST /assertions
  def create
    @assertion = Assertion.new(assertion_params)

    if @assertion.save
      render json: @assertion, status: :created, location: @assertion
    else
      render json: @assertion.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /assertions/1
  def update
    if @assertion.update(assertion_params)
      render json: @assertion
    else
      render json: @assertion.errors, status: :unprocessable_entity
    end
  end

  # DELETE /assertions/1
  def destroy
    @assertion.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_assertion
    @assertion = Assertion.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def assertion_params
    params.require(:assertion).permit(:url, :text, :status, :snapshotUrl, :numLinks, :numImages)
  end
end
