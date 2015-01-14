require 'rubygems'
require 'bundler/setup'

require 'plist'
require 'parse-ruby-client'
require 'cfpropertylist'

require_relative 'paths.rb'

def generateChangelogs (plist_path)
  
  plist_content = CFPropertyList::List.new(file: plist_path)
  deployments   = CFPropertyList.native_types(plist_content.value)
  
  deployments.each do |deploy|
    
    generateChangelog deploy
    
  end

end


def generateChangelog (deploy)
      
    settings      = load_settings deploy
    changelogPath = changelogPath(settings)
    previousTag   = settings[:deploy]["build"]["previousGitTag"]
    currentTag    = settings[:deploy]["build"]["currentGitTag"]

    name        = 'mercure'
    g           = Gem::Specification.find_by_name( name )
    script_path = File.join( g.full_gem_path, 'lib/mercure/changelog.sh' )

    puts "#{script_path} #{previousTag} #{currentTag} #{changelogPath}"

    system("#{script_path} #{previousTag} #{currentTag} #{changelogPath}")
    
end
