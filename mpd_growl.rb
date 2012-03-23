require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :app)
require 'yaml'

class MPDClient
  attr_accessor :first_run, :growl, :growl_method, :mpd
  NOTIFICATION_TYPES = { :song_change => "MPD Song Change Notification" }
  GROWL_METHODS = { :growlnotify => "growlnotify", :ruby => 'ruby-growl'}

  def initialize(mpd, growl_host, growl_method)
    self.mpd = mpd
    self.first_run = true
    self.growl = Growl.new(growl_host, "MPD Growl", NOTIFICATION_TYPES.values)
    self.growl_method = growl_method
  end

  def current_song_callback(song)
    self.first_run = false
    if song
      case self.growl_method
      when GROWL_METHODS[:growlnotify] then system(%(growlnotify -n "MPD Growl" -a iTunes -t "#{song.title}" -m "#{song.artist}\n#{song.album}"))
      when GROWL_METHODS[:ruby] then self.growl.notify(NOTIFICATION_TYPES[:song_change], song.title, "#{song.artist}\n#{song.album}")
      end
    end
  end

  def state_callback(state)
    return if self.first_run
    current_song_callback(self.mpd.current_song) if self.mpd.playing?
  end
end

def load_config
  config = { "config" => { } }
  config_file = File.join(File.expand_path(File.dirname(__FILE__)), "config.yaml")
	config = YAML.load_file(config_file) if File.exists?(config_file)
	@mpd_host     = config["config"]["mpd_host"]     || 'localhost'
	@mpd_port     = config["config"]["mpd_port"]     || 6600
  @growl_host   = config["config"]["growl_host"]   || 'localhost'
  @growl_method = config["config"]["growl_method"] || MPDClient::GROWL_METHODS[:ruby]
end

load_config
mpd = MPD.new(@mpd_host, @mpd_port)
client = MPDClient.new(mpd, @growl_host, @growl_method)

mpd.register_callback(client.method('current_song_callback'), MPD::CURRENT_SONG_CALLBACK)
mpd.register_callback(client.method('state_callback'), MPD::STATE_CALLBACK)

# Connect and Enable Callbacks
mpd.connect( true )
sleep
