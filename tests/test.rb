require 'minitest/autorun'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'teamspeak-ruby'

class TeamspeakTest < MiniTest::Unit::TestCase
  def setup
    @ts = Teamspeak::Client.new
    @ts.login('serveradmin', 'travis_test')
    @ts.command('use', {'sid' => 1})
  end

  def test_get_hostinfo
    assert(@ts.command('hostinfo')['host_timestamp_utc'])
  end

  def test_get_clients
    @ts.command('clientlist').each do |user|
      assert(user['client_nickname'])
    end
  end

  def test_get_serverinfo
    assert_equal(@ts.command('serverinfo')['virtualserver_name'], 'TeamSpeak ]I[ Server')
  end

  def test_flood_protection
    15.times do
      assert(@ts.command('hostinfo')['host_timestamp_utc'])
    end
  end

  def teardown
    @ts.disconnect
  end
end
