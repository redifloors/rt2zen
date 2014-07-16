require 'minitest/autorun'

require 'rt2zen'

def config
  {
    site: ENV['RT_SITE'],
    user: ENV['RT_USER'],
    pass: ENV['RT_PASS'],
  }
end

module RT2Zen
  # Open the RT Module and insert accessors for testing
  module RT
    class << self; attr_accessor :site, :user, :pass end
  end

  class TestRT < Minitest::Test
    def setup
      if ENV['RT_SITE'].nil? or ENV['RT_USER'].nil? or ENV['RT_PASS'].nil?
        abort 'You must set RT_SITE, RT_USER, and RT_PASS environment variables first'
      else
        RT.connect config
      end
    end

    def test_connection
      RT.disconnect()
      assert_raises ArgumentError do
        RT.connect()
      end
    end

    def test_valid
      assert RT.valid?, 'Expected RT.valid? to return true'
      RT.disconnect
      refute RT.valid?, 'Expected RT.valid? to return false'
    end

    def test_site
      assert RT.valid?, 'RT Should be valid'
      assert_match /#{ENV['RT_SITE']}/, RT::site
      RT.site = nil
      assert_nil RT::site, 'RT::site should be nil'
      refute RT.valid?, 'RT Should not be valid any longer'
    end

    def test_user
      assert RT.valid?, 'RT Should be valid'
      assert_equal ENV['RT_USER'], RT::user
      RT.user = nil
      assert_nil RT::user, 'RT::user should be nil'
      refute RT.valid?, 'RT Should not be valid any longer'
    end

    def test_pass
      assert RT.valid?, 'RT Should be valid'
      assert_equal ENV['RT_PASS'], RT::pass
      RT.pass = nil
      assert_nil RT::pass, 'RT::pass should be nil'
      refute RT.valid?, 'RT Should not be valid any longer'
    end

  end

  class TestTickets < Minitest::Test

    def setup
      RT.connect config
    end

    def teardown
      RT.disconnect
    end

    def test_get
      assert_match /RT.* 200 Ok/, RT.get('ticket/1/show')
      assert_nil RT.get('/foo/bar/bat')
      RT.disconnect()
      assert_raises RuntimeError do
        RT.get('/test')
      end
    end

    def test_get_data
      hash = RT.get_data('ticket/1/show')
      assert_instance_of Hash, hash
      assert hash.has_key?(:id), 'RT.get_data is not returning an id key'
    end

    def test_find
      ticket = RT::Ticket.find(1)
      assert_instance_of RT::Ticket, ticket
      assert_equal 1, ticket.id
    end

    def test_invalid_ticket
      assert_raises RuntimeError do
        RT::Ticket.new(nil)
      end
    end
  end
end
