# MPD_Growl

MPD_Growl is a simple ruby script for creating [Growl](http://growl.info/) notifications based on [MPD](http://sourceforge.net/projects/musicpd/) events.

## Requirements
You're going to need `bundler`

``` ruby
gem install bunder
```

## Installation
Simply clone the repo and run

``` ruby
bundle install
```

## Configuration
Included is a sample configuration file `config.yaml.sample`. It's a pretty simple file that has host and port information for your MPD server and the Growl notification method. There are currently 2 supported notification methods:

#### ruby-growl
The ruby-growl method uses the `ruby-growl` gem to communicate with Growl via the network. In order to have this method work, you must enable the options:

> Listen for incoming notifications
> 
> Allow remote application registration

Both of there can be found in your Growl->Network settings pane.


#### growlnotify
The growlnotify method uses the `growlnotify` application ([info here](http://growl.info/extras.php)) that is included with Growl. It does not require setting any of the Network options that `ruby-growl` does.

## Usage
MPD_Growl uses [Daemons](http://daemons.rubyforge.org/) to simplify running the script as a long running, background process. To start the script, simply run:

``` ruby
ruby mpd.rb start
```

You can stop the process by running:

``` ruby
ruby mpd.rb stop
```

You can restart a running process by running:

``` ruby
ruby mpd.rb restart
```

Finally, you can also run the script in the foreground by running:

``` ruby
ruby mpd.rb run
```
