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

    def campfire_room(params)
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

      RestClient.post "https://voonami.campfirenow.com/room/#{campfire_room(params)}/speak.json", json_data, {:authorization => 'Basic MmYwZTIzNTIwMTBmN2EyOWZhNTAzMWZiM2FkYmU4OTIzOGM4ZmFhMTo=', :content_type => :json}

      status '200'
    end

    post '/created' do

      ap params

      msg = "A new ticket has been opened in the #{get_department(params.fetch("department_id", 0).to_i)} department. Title: '#{params.fetch("subject")}' (https://support.voonami.com/admin/supportmgr/ticket_view.php?ticket=#{params.fetch("ticket_id", 0)})"

      send_to_campfire(msg)
    end

    post '/assigned' do

      ap params

      msg = "A ticket has been re-assigned from #{params.fetch("old_user", "Unassigned")} to #{params.fetch("new_user", "Unassigned")}.\n(https://support.voonami.com/admin/supportmgr/ticket_view.php?ticket=#{params.fetch("ticket_id", 0)})"

      send_to_campfire(msg)
    end

    post '/closed' do

      ap params

      msg = "A ticket has been Closed.\n(https://support.voonami.com/admin/supportmgr/ticket_view.php?ticket=#{params.fetch("ticket_id", 0)})"

      send_to_campfire(msg)
    end

    post '/edited' do

      ap params

      msg = "A ticket has been Changed.\n(https://support.voonami.com/admin/supportmgr/ticket_view.php?ticket=#{params.fetch("ticket_id", 0)})"

      send_to_campfire(msg)
    end
  end
end
