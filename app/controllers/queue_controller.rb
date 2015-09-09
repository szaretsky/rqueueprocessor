require 'queuestorage.rb'
require 'rest-client'

class QueueController < ApplicationController
  respond_to :html,:js
  def index
    @events = QueueStorage.limit(10).offset(20)
  end

  def status
    @statuses = JSON.parse(RestClient.post "http://127.0.0.1:2345", { 'get' => 'stats' }.to_json+"\r\n", :content_type => :json, :accept => :json)
    @statuses.each do |queuestat| 
      queuestat['qlen'] = QueueStorage.where( queueid: queuestat['queueid'], status: 1 ).count
      queuestat['eps'] = (queuestat['eps'] * queuestat['workers']).round.to_int
    end
  end

  def workerschange
    known_commands = [:workers, :frame, :queueid]
    commands = params.permit(known_commands)
    request = { 'queueid' => params['queueid'] }
    known_commands.each { |cmd| request[cmd] = commands[cmd] if commands[cmd] }
    result = RestClient.post "http://127.0.0.1:2345", { 'set' => [request] }.to_json+"\r\n", :content_type => :json, :accept => :json
    redirect_to action: 'status'
  end
    
end
