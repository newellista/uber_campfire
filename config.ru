require 'bundler'
Bundler.require

require File.expand_path '../app.rb', __FILE__
require File.expand_path '../ticket.rb', __FILE__

map '/ticket' do
  run UberReactor::Tickets
end

