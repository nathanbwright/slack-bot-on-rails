class CannonController < ApplicationController
  def index
    resp = Net::HTTP.get(uri)
    hash = JSON.parse(resp)
    image_urls = []
    response_array = hash['data'].flat_map do |i|
      image_urls << i['images']['original']['url']
    end.uniq
    # render json: { responses: response_array.first }
    render json: { blocks: [], text: response_array.first }
  end

  private

  def params
    params.permit[:query, :limit]
  end

  def uri 
    host = 'https://api.giphy.com'
    path = '/v1/gifs/search?'
    api_key = '1DQmGfGPPrqCnbSCZCdEULfqjAvxWq5B'
    query = 'princess bride'
    rating = 'g'
    params = { api_key: api_key, q: query, limit: 5, offset: 0, rating: rating }.to_param
    uri = URI(host + path + params)
  end
end
