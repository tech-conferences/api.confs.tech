require 'rss'

class Api::ConferencesController < ApiController
  skip_before_action :authenticate_request
  before_action :validate_topics, only: :create
  before_action :validate_params, only: :create

  def index
    @conferences = Conference.first(limit)
    rss = RSS::Maker.make('2.0') do |maker|
      maker.channel.author = 'Confs.tech'
      maker.channel.updated = @conferences.first.created_at.to_time.to_s
      maker.channel.link = 'https://confs.tech'
      maker.channel.description = 'Confs.tech | List of tech conferences: JavaScript, UX / Design, Ruby'
      maker.channel.title = 'Confs.tech'

      @conferences.map do |conference|
        maker.items.new_item do |item|
          item.link = conference.url
          item.title = conference.name
          item.description = "#{conference.location_to_s} | #{conference.start_date.strftime('%B, %-d')}"
          item.description += " | #{conference.topics.map{ |t| "##{t.name}" }.join(', ')}"
          item.pubDate = conference.start_date.to_s
        end
      end
    end

    render json: rss.to_s
  end

  def cfp
    @conferences = Conference.where.not(cfpStartDate: nil).first(limit)
    rss = RSS::Maker.make('2.0') do |maker|
      maker.channel.author = 'Confs.tech'
      maker.channel.updated = @conferences.first.created_at.to_time.to_s
      maker.channel.link = 'https://confs.tech'
      maker.channel.description = 'Confs.tech | List of tech conferences: JavaScript, UX / Design, Ruby'
      maker.channel.title = 'Confs.tech - CFP'

      @conferences.map do |conference|
        maker.items.new_item do |item|
          item.link = conference.cfpUrl
          item.title = conference.name
          item.description = "#{conference.location_to_s} | #{conference.start_date.strftime('%B, %-d')}"
          item.description += " | #{conference.topics.map{ |t| "##{t.name}" }.join(', ')}"
          item.pubDate = conference.cfpEndDate.to_s
        end
      end
    end

    render json: rss.to_s
  end

  def create
    conference = Conference::CreationService.run!(params: create_params)

    render json: conference
  end

  private

  def validate_topics
    create_params[:topics].detect do |topic|
      if Topic.where(name: topic).length.zero?
        render json: { error: 'topic' }, status: :unprocessable_entity
      end
    end

    if create_params[:topics].length.zero?
      render json: { error: 'topic' }, status: :unprocessable_entity
    end
  end

  def validate_params
    conf = Conference.new(create_params.except(:topics))

    render json: { error: conf.errors }, status: :unprocessable_entity unless conf.valid?
  end

  def index_params
    params.permit(:limit)
  end

  def limit
    if index_params[:limit] && index_params[:limit].to_i <= 50
      index_params[:limit].to_i
    else
      15
    end
  end

  def create_params
    params.permit(
      :name,
      :startDate,
      :endDate,
      :city,
      :country,
      :online,
      :cfpUrl,
      :cfpEndDate,
      :twitter,
      :cocUrl,
      :offersSignLanguageOrCC,
      :url,
      topics: []
    ).to_h
  end
end
