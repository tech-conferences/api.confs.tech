class ApiController < ActionController::Base
  before_action :authenticate_request

  private

  def authenticate_request
    authenticated = params[:auth] == ENV['AUTH_TOKEN']

    render json: { error: 'Not Authorized' }, status: 401 unless authenticated
  end
end
