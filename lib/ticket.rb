require 'rubygems'
require 'sinatra'
require 'sinatra/base'

require 'pry'
require 'pry-nav'
require 'awesome_print'

# receive POST from uber
# Format JSON message for Campfire
# POST JSON message to Campfire

module UberReactor
  class Tickets < Sinatra::Base
    helpers Sinatra::JSON

    configure do
      @@departments = {
        0 => "Invalid Department",
        1 => "Support",
        2 => "Sales",
        3 => "Billing",
        4 => "Internal",
        7 => "Provisioning",
        12 => "IT",
        13 => "Alerts",
        14 => "IT Alerts"
      }
    end

    def get_department( department_id )
      puts department_id
      @@departments.fetch(department_id)
    end

    def campfire_room
      '580148'
    end

    def send_to_campfire(msg)
      body = {
        :message => {
          :type => "TextMessage",
          :body => msg
        }
      }

      json_data = JSON.generate(body)

      RestClient.post "https://voonami.campfirenow.com/room/#{campfire_room}/speak.json", json_data, {:authorization => 'Basic MzlhNWY1Mjk1MzhjNDBiOGVkNzJlMmYxYzI4ZTRhMDViZGE3Zjg0Nzo=', :content_type => :json}

      status '200'
    end

    def created_msg(params)
      "OPENED (#{get_department(params.fetch("department_id", 0).to_i)})::'#{params.fetch("subject")}' (https://support.voonami.com/admin/supportmgr/ticket_view.php?ticket=#{params.fetch("ticket_id", 0)})"
    end

    def assigned_msg(params)
      "REASSIGNED (#{params.fetch("old_user", "Unassigned")} -> #{params.fetch("new_user", "Unassigned")})::'#{params.fetch("subject")}' (https://support.voonami.com/admin/supportmgr/ticket_view.php?ticket=#{params.fetch("ticket_id", 0)})"
    end

    def closed_msg(params)
      "CLOSED::'#{params.fetch("subject")}' (https://support.voonami.com/admin/supportmgr/ticket_view.php?ticket=#{params.fetch("ticket_id", 0)})"
    end

    def changed_msg(params)
      "CHANGED::'#{params.fetch("subject")}' (https://support.voonami.com/admin/supportmgr/ticket_view.php?ticket=#{params.fetch("ticket_id", 0)})"
    end

    post '/created' do
      logger.info params.inspect
      send_to_campfire(created_msg(params))
    end

    post '/assigned' do
      logger.info params.inspect
      send_to_campfire(assigned_msg(params))
    end

    post '/closed' do
      logger.info params.inspect
      send_to_campfire(closed_msg(params))
    end

    post '/edited' do
      logger.info params.inspect
      send_to_campfire(changed_msg(params))
    end
  end
end
