class ApplicationController < ActionController::API
  protected

  def per_page
    50
  end

  def page
    max(1, params["page"].to_i)
  end
end
