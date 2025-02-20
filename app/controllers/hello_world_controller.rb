class HelloWorldController < Sinatra::Base
  def get_message
    { message: "Hello, World!" }.to_json
  end

  get '/' do
    content_type :json
    get_message
  end
end