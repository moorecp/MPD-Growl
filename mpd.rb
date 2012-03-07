require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :daemon)

Daemons.run('mpd_growl.rb')
