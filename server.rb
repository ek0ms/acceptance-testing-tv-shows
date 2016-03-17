require 'sinatra'
require 'csv'
require 'pry'
require_relative "app/models/television_show"

set :views, File.join(File.dirname(__FILE__), "app/views")


get '/television_shows' do
  @tv_show_list = []
  CSV.foreach('television-shows.csv', :headers => true, :header_converters => :symbol) do |row|
    @tv_show_list << row
  end
  @tv_show_list_array = @tv_show_list.map { |row| row.to_hash }
  erb :index
end

get '/television_shows/new' do
  erb :new
end

post '/television_shows/new' do
  @error = nil
  @tv_show_list = []
  CSV.foreach('television-shows.csv', :headers => true, :header_converters => :symbol) do |row|
    @tv_show_list << row
  end
  @tv_show_list_array = @tv_show_list.map { |row| row.to_hash }
  @tv_show_titles = []
  @tv_show_list_array.each do |tv_show|
    @tv_show_titles << tv_show[:title]
  end

  title = params['title']
  network = params['network']
  starting_year = params['starting_year']
  synopsis = params['synopsis']
  genre = params['Genre']
  data = [title, network, starting_year, synopsis, genre]

  if data.include?("")
    @error = "Please fill in all required fields"
  elsif @tv_show_titles.include?(data[0])
    @error = "The show has already added"
  else
    CSV.open('television-shows.csv', 'ab') do |csv|
      csv.puts(data)
    end

    redirect '/television_shows'
  end

  erb :new
end
