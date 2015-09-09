#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)
p root

require "#{File.dirname __FILE__}/../../config/environment"
require 'queueprocessor'

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  
  # Replace this with your code
  #Rails.logger.auto_flushing = true
  #Rails.logger.info "This daemon is still running at #{Time.now}.\n"


  f1 = lambda do |event,qp,conn|
    qp.put("2","Event #{event.dbid}/#{rand}", conn)
    sleep(0.1);
    0/rand(100).round  # add some failed events
  end

  f2 = lambda do |event,qp,conn|
    qp.put("1","Event #{event.dbid}/#{rand}", conn)
    sleep(0.1);
  end
  connhash = {}
  if ENV['DATABASE_URL']
    connhash[:connstr] = ENV['DATABASE_URL']
  else
    connhash[:dbname] = 'queues_development'
  end
  qp = PGQueueProcessor::PGQueueProcessor.new(
    [
      {:queueid => 1, :workers => 2, :frame => 100, :handler => f1 },
      {:queueid => 2, :workers => 3, :frame => 100, :handler => f2 }
    ], connhash)
  qp.masterrun


  
  sleep 10
end
