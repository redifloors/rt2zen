require 'net/http'

module RT2Zen
  module RT

    def self.connect(args)
      @site = args[:site] || raise(ArgumentError, 'Site URL is required')
      @user = args[:user] || raise(ArgumentError, 'Username is required')
      @pass = args[:pass] || raise(ArgumentError, 'Password is required')
      @site = "http://#{@site}" unless @site =~ /^http/
    end

    def self.disconnect
      @user = @pass = @site = nil
    end

    def self.get(url, params = {})
      raise RuntimeError, 'Please use RT.connect() prior to other method calls' unless self.valid?
      raise ArgumentError, 'URL cannot be nil' if url.nil?

      uri = URI("#{@site}/REST/1.0/" + url)
      uri.query = URI.encode_www_form(params) unless params.nil? or params.empty?

      req = Net::HTTP::Post.new(uri)
      req.set_form_data('user' => @user, 'pass' => @pass)

      res = Net::HTTP.start(uri.hostname, uri.port,
                            :use_ssl => uri.scheme == 'https',
                            :set_debug_output => $stderr) do |http|
        http.request(req)
      end

      # uri = URI(url)
      # uri.query = URI.encode_www_form(params) unless params.empty?
      # http.request_get(uri)

      case res
        when Net::HTTPSuccess, Net::HTTPRedirection
          raise RuntimeError, 'Invalid credentials' if res.body =~ /RT.* 401/
          return if res.body =~ /Unknown object type/
          res.body
        else
          nil
      end
    end

    def self.get_data(url, params = {})
      data = {}

      response = get(url, params)
      return if response.nil?

      response.split("\n").each do |query|
        d = /(.*?):\s(.*)/.match(query).to_a[1,2]
        next unless d
        data[d[0].downcase.to_sym] = d[1].to_s
      end
      data
    end

    def self.valid?
      !( @user.nil? or @pass.nil? or @site.nil? )
    end

    class Ticket
      def initialize(id)
        raise RuntimeError, 'ID is a required data attribute to create a ticket' if id.nil?

        id = /\d+/.match(id)[0].to_i # pull integers out of string
        raise ArgumentError, 'ID is invalid' if id.nil?

        @id      = id
        @data    = RT.get_data("ticket/#{id}/show")
      end
      attr_reader :id

      def self.find(ticket)
        raise ArgumentError, 'Ticket cannot be nil' if ticket.nil?
        data = RT.get_data("ticket/#{ticket}/show")
        self.new(data[:id]) if data.has_key?(:id)
      end
    end

    class Tickets
      def initialize(query = nil)
        @tickets = []
        params = { query: query || %q(Status = 'open') }
        RT.get_data('search/ticket', params).each_key { |id| @tickets << Ticket.new(id) }
      end

      def count
        @tickets.count
      end
    end
  end
end
