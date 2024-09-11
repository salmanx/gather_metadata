# frozen_string_literal: true

class AssertionsController < ApplicationController
  before_action :set_assertion, only: %i[show]

  def index
    @assertions = Assertion.all

    render json: @assertions
  end


  def create
    @assertion = Assertion.new(assertion_params)

    if @assertion.save
      render json: @assertion, status: :created, location: @assertion
    else
      render json: @assertion.errors, status: :unprocessable_entity
    end
  end



  private

  def set_assertion
    @assertion = Assertion.find(params[:id])
  end

  def assertion_params
    params.require(:assertion).permit(:url, :text)
  end
end
