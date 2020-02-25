require 'rails_helper'

RSpec.describe 'Crawls', type: :request do
  describe 'GET /new' do
    it 'returns http success' do
      get '/crawl/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /profile' do
    it 'returns http success' do
      get '/crawl/profile'
      expect(response).to have_http_status(:success)
    end
  end
end
