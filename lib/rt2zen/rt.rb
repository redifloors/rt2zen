module RT2Zen
  module RT
    require 'net/http'

    def self.connect(args)
      @site = args[:site] || raise(ArgumentError, 'Site URL is required')
      @user = args[:user] || raise(ArgumentError, 'Username is required')
      @pass = args[:pass] || raise(ArgumentError, 'Password is required')
    end

    def self.disconnect
      @user = @pass = @site = nil
    end

    def self.get(url)
      raise RuntimeError, 'Please use RT.connect() prior to other method calls' unless self.valid?
      raise ArgumentError, 'URL cannot be nil' if url.nil?

      uri = URI("#{@site}/REST/1.0/" + url)
      raise RuntimeError 'Invalid URL' if uri.nil?

      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data('user' => @user, 'pass' => @pass)

      res = Net::HTTP.start(uri.hostname, uri.port,
                            :use_ssl => uri.scheme == 'https',
                            :set_debug_output => $stderr) do |http|
        http.request(req)
      end

      case res
        when Net::HTTPSuccess, Net::HTTPRedirection
          return nil if res.body =~ /Unknown object type/
          res.body
        else
          nil
      end
    end

    def self.valid?
      ( defined?(@user) and !@user.nil? ) and
      ( defined?(@pass) and !@pass.nil? ) and
      ( defined?(@site) and !@site.nil? )
    end

    class Ticket
      def initialize(res)
        @response = res
      end
      attr_reader :response

      def self.find(ticket)
        raise ArgumentError, 'Ticket cannot be nil' if ticket.nil?
        res = RT.get("ticket/#{ticket}/show")
        self.new(res) if res
      end
    end

  end
end
