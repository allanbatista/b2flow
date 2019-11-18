class ApplicationController < ActionController::API
  protected

  def per_page
    50
  end

  def page
    [1, params["page"].to_i].max
  end
end
