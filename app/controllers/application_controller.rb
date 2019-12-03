class ApplicationController < ActionController::API
  protected

  def per_page
    [[1, (params["per_page"] || "50").to_i].max, 100].min
  end

  def page
    [1, params["page"].to_i].max
  end
end
