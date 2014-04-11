require "linkedin-scraper"
require "sinatra"
require "./comparer.rb"

set :server, 'webrick'

enable :logging

before do
  logger.level = Logger::DEBUG
end

get "/" do
  erb :index
end

post "/results" do
  profile_urls = [
    params[:original_profile_url],
    params[:other_profiles_url].split( /\r\n|\n|\r/ )
  ].flatten

  #profile_urls = [
  #  "http://de.linkedin.com/in/jvsantos",
  #  "http://www.linkedin.com/in/plfcoelho",
  #  "http://pt.linkedin.com/in/rsneves",
  #  "http://pt.linkedin.com/in/martapereira",
  #  "http://lv.linkedin.com/pub/raimonds-samofals/3a/277/8ab"
  #]

  profiles = profile_urls.map do |profile_url|
    Linkedin::Profile.get_profile profile_url
  end

  ranks = profiles[0].rank profiles[1..-1]
  erb :results, locals: {ranks: ranks.sort_by{ |r| r[:affinity] }.reverse }
end
