require 'rt2zen'
require 'pp'

module RT2Zen

  RT.connect({
      site: 'http://help.redifloors.com',
      user: ENV['RT_USER'],
      pass: ENV['RT_PASS'],
  })

  tickets = RT::Tickets.new(%q(Status='resolved'))

  # pp tickets

  puts "Found #{tickets.count} open tickets"

  # tickets = RT::Ticket.new config
  # p tickets.find(1002)

end
