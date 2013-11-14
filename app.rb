require 'rubygems'
require 'sinatra'
require 'sinatra/base'

module UberReactor
  class Main < Sinatra::Base
    configure :production, :development do
      enable :show_exceptions
      enable :logging
    end
  end
end
