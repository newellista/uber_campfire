require 'bundler'
Bundler.require

set :environment, ENV['RACK_ENV'].to_sym || 'development'
disable :run, :reload

require File.expand_path '../lib/app.rb', __FILE__
require File.expand_path '../lib/ticket.rb', __FILE__

map '/ticket' do
  run UberReactor::Tickets
end

