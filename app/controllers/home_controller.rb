class HomeController < Sinatra::Base
  set :views, File.expand_path('../../views', __FILE__) # Set views directory

  get '/' do
    send_file File.join(settings.views, 'index.html')
  end
end