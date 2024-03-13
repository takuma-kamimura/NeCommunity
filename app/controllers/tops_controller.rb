class TopsController < ApplicationController
  skip_before_action :require_login

  def top; end

  def kiyac; end

  def policy; end

  def guide; end
end
