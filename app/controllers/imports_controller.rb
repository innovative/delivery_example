class ImportsController < ApplicationController
  before_filter :require_token

  def create
    # optionally, in Thread.new { ... }
    params[:import].each do |model_name, collection|
      klass = model_name.camelize.constantize # will find Item, etc.

      collection.each do |attributes|
        klass.create_from_import(attributes)
      end
    end

    # sleep 10 # simulate slowness in creation, thus Thread.new above

    # always render immediately
    render nothing: true, status: :created
  end

  # below is what I'm posting, approximately
  # Faraday.new.post do |request|
  #   request.url 'http://abcdefg@localhost:3000/import'
  #   request.options[:timeout] = 5
  #   request.headers['Content-Type'] = 'application/json'
  #   request.body = {"item" => [1,2,3]}.to_json
  # end

  private

  def require_token
    authenticate_with_http_basic do |token, _|
      if token == 'abcdefg'
        render nothing: true, status: :access_denied
        false
      else
        true
      end
    end
  end
end
