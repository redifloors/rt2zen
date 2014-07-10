require 'rt2zen'

module RT2Zen
  config = {
      site: 'http://help.redifloors.com',
      user: ENV['RT_USER'],
      pass: ENV['RT_PASS'],
  }

  RT.connect(config)
  ticket = RT::Ticket.find(1002)
  p ticket.response

  # tickets = RT::Ticket.new config
  # p tickets.find(1002)

end
