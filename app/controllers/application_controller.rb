class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    authenticated = params[:auth] == Rails.application.secrets.auth
    render json: { error: 'Not Authorized' }, status: 401 unless authenticated
  end
end
