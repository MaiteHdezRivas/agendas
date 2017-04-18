namespace :tsvector do

  task :event => :environment do
    events = Event.all

    puts 'Init save ts_vector to event'
    events.each do |event|
      event.record_timestamps = false
      event.save
      event.record_timestamps = true
    end
    puts 'End save ts_vector to event'
  end


  task :holder => :environment do
    holders = Holder.all

    puts 'Init save ts_vector to holder'
    holders.each do |holder|
      puts "Init save ts_vector to #{holder}"
      holder.record_timestamps = false
      holder.save
      holder.record_timestamps = true
    end
    puts 'End save ts_vector to holder'
  end
end
