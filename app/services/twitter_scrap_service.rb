class TwitterScrapService
  require 'net/http'
  require 'json'
  attr_reader :url, :token

  def initialize(args)
    @url = args[:url]
    @token = args[:token]
  end

  def crawl_data
    uri = URI('https://api.proxycrawl.com')
    uri.query = URI.encode_www_form({
                                      token: token,
                                      format: 'json',
                                      url: url
                                    })
    response = Net::HTTP.get_response(uri)
    parsing_profile_data(response)
  end

  private

  def parsing_profile_data(res)
    json = JSON.parse(res.body)
    parsed_data = Nokogiri::HTML.parse(json['body'])
    profile_data(parsed_data)
  end

  def profile_data(parsed_data)
    data = {
      'name' => parsed_data.css('.ProfileHeaderCard-nameLink').text,
      'bio_card' => parsed_data.css('.ProfileHeaderCard-bio').text,
      'join_date' => parsed_data.css('.ProfileHeaderCard-joinDateText').text,
      'handle' => parsed_data.css('.ProfileHeaderCard-screennameLink span').text
    }
    parsed_data.css('.ProfileNav-list .ProfileNav-stat').each do |d|
      key = d.attributes['data-nav']&.value
      data[key] = d.attributes['title']&.value
    end
    save_data(data)
    data
  end

  def save_data(profile_data)
    File.open("public/#{profile_data['name'].parameterize}-twitter.json", 'w') do |f|
      f.write(profile_data.compact)
    end
  end
end
