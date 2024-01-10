class ApplicationController < ActionController::Base
  before_action :require_login
  # skip_before_action :verify_authenticity_token, only: :receive
  # protect_from_forgery
end
