require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :app)

class MPDClient
  attr_accessor :first_run, :growl, :mpd
  NOTIFICATION_TYPES= { :song_change => "MPD Song Change Notification" }

  def initialize(mpd)
    self.mpd = mpd
    self.first_run = true
    self.growl = Growl.new("localhost", "MPD Growl", NOTIFICATION_TYPES.values)
  end

  def current_song_callback(song)
    self.first_run = false
    if song
      self.growl.notify(NOTIFICATION_TYPES[:song_change], song.title, "#{song.artist}\n#{song.album}")
      # system "growlnotify -n "MPD Growl" -a iTunes -t \"#{song.title}\" -m \"#{song.artist}\n#{song.album}\""
    end
  end

  def state_callback(state)
    return if self.first_run
    current_song_callback(self.mpd.current_song) if self.mpd.playing?
  end
end

mpd = MPD.new('localhost', 6600)
client = MPDClient.new(mpd)

mpd.register_callback(client.method('current_song_callback'), MPD::CURRENT_SONG_CALLBACK)
mpd.register_callback(client.method('state_callback'), MPD::STATE_CALLBACK)

# Connect and Enable Callbacks
mpd.connect( true )
sleep
