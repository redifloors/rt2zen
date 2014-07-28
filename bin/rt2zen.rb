require 'rt2zen'
require 'pp'

module RT2Zen

  unless ENV['RT_USER'] or ENV['RT_PASS']
    puts 'Please supply RT_USER and RT_PASS environment variables'
    exit 1
  end

  RT.connect({
      site: 'http://help.redifloors.com',
      user: ENV['RT_USER'],
      pass: ENV['RT_PASS'],
  })

  # tickets = RT::Tickets.new(%q(Status='resolved'))
  tickets = RT::Tickets.new(1) # for testing

  puts "Found #{tickets.count} open tickets"

  tickets.each do |ticket|
    pp ticket
  end

end
