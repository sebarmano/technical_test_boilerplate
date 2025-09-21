class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_client
  before_action :require_json
  rate_limit to: 10, within: 1.minute

  private

  def authenticate_client
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.active.find_by(key: token).present?
    end
  end

  def require_json
    if !request.format.json?
      head 406
    end
  end
end
