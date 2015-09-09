class QueueStorage < ActiveRecord::Base
  self.table_name = 'queues'
  self.primary_key = 'eventid'
  #Client.limit(5).offset(30)
end
