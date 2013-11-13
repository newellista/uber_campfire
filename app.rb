require 'rubygems'
require 'sinatra'
require 'sinatra/base'

class UberReactor < Sinatra::Base
  configure :production, :development do
    enable :show_exceptions
    enable :logging
  end

  post '/*.*' do
    logger.info "POST received"
  end

  put '/*.*' do
    logger.info "PUT received"
  end

  get '/*' do
    logger.info "GET received"
    logger.info "#{request.inspect}"
    'Hello World'
  end
end
