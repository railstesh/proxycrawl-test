class CrawlController < ApplicationController
  def new; end

  def scrap
    response = TwitterScrapService.new(scrap_params).crawl_data
    redirect_to profile_crawl_index_path(response.as_json)
  end

  def profile
    @profile = params.except('controller', 'action').as_json
  end

  private

  def scrap_params
    params.permit(:url, :token)
  end
end
