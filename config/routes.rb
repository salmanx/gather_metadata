# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      resources :assertions, only: %i[index create]
      get 'snapshots/:id', to: 'assertions#fetch_snapshot', as: 'snapshots'
    end
  end
end
