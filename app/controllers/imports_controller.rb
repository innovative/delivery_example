class ImportsController < ApplicationController
  before_filter :require_token

  def create
    retailer = params[:retailer]
    retailer_ics_id = retailer["ezport"].to_i - 30_000 # => 999 for our fictional retailer

    # optionally, in Thread.new { ... }
    params[:package].each do |model_name, collection|
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
  # connection = Faraday.new
  # connection.token_auth 'abcefg'

  # connection.post do |request|
  #   request.url 'http://localhost:3111/import'
  #   request.options[:timeout] = 5
  #   request.headers['Content-Type'] = 'application/json'
  #   request.body = {"retailer" => {"id" => 12, "name" => "Beer Haus", "ezport" => 30999}, "package" => {"item" => [1,2,3]}}.to_json
  # end

  private

  def require_token
    puts "inside require_token"

    authenticate_with_http_token do |token, _|
      puts "inside http basic block: #{token}"

      if token != 'abcdefg'
        render nothing: true, status: :unauthorized and return false
      else
        true
      end
    end
  end
end
