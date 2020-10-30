class CannonController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create 
    resp = Net::HTTP.get(uri)
    hash = JSON.parse(resp)
    image_urls = []
    response_array = hash['data'].flat_map do |i|
       { 
          type: "image",
          image_url: i['images']['original']['url'],
          alt_text: i['title']
        }
    end.uniq

    render json: { blocks: response_array }
  end

  private

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
