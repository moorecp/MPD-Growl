require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :app)

class MPDClient
  attr_accessor :growl
  NOTIFICATION_TYPES= { :song_change => "MPD Song Change Notification" }
  def initialize
    self.growl = Growl.new("localhost", "MPD Growl", NOTIFICATION_TYPES.values)
  end

  def current_song_callback(song)
    if song
      self.growl.notify(NOTIFICATION_TYPES[:song_change], song.title, "#{song.artist}\n#{song.album}")
      # system "growlnotify -n "MPD Growl" -a iTunes -t \"#{song.title}\" -m \"#{song.artist}\n#{song.album}\""
    end
  end
end

client = MPDClient.new
mpd = MPD.new('localhost', 6600)
mpd.register_callback(client.method('current_song_callback'), MPD::CURRENT_SONG_CALLBACK)

# Connect and Enable Callbacks
mpd.connect( true )
sleep
