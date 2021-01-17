class Api::ConferencesController < ApiController
  skip_before_action :authenticate_request
  before_action :validate_topic, only: :create
  before_action :validate_params, only: :create

  def create
    conference = Conferences::CreationService.run!(params: create_params)

    render json: conference
  end

  private

  def validate_topic
    if Topic.where(name: create_params[:topic]).length.zero?
      render json: { error: 'topic' }, status: 422
    end
  end

  def validate_params
    conf = Conference.new(create_params.except(:topic))

    if !conf.valid?
      render json: { error: conf.errors }, status: 422
    end
  end

  def create_params
    params.permit(
      :name,
      :url,
      :startDate,
      :endDate,
      :city,
      :country,
      :twitter,
      :topic,
      :cfpUrl,
      :cfpEndDate,
      :cocUrl,
      :online,
      :offersSignLanguageOrCC,
    ).to_h
  end
end
