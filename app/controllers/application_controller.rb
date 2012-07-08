class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :log_request
  after_filter :log_response

  private

  # TODO: Add request id here
  def log_request
    logger.info "HTTP request received => #{request.fullpath} , params => #{params} "
  end

  def log_response
    logger.info "HTTP response => #{response_body}"
  end

end
