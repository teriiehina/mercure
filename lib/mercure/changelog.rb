require 'rubygems'
require 'bundler/setup'

require 'plist'
require 'parse-ruby-client'

require_relative 'paths.rb'

def generateChangelog (settings)

  changelogPath = changelogPath(settings)
  
  previousTag   = settings[:deploy]["build"]["previousGitTag"]
  currentTag    = settings[:deploy]["build"]["currentGitTag"]

  system("mercure_changelog #{previousTag} #{currentTag} #{changelogPath}")

end