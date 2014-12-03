require 'rubygems'
require 'bundler/setup'

require 'net/scp'
require 'net/ftp'
require 'net/ssh'

require 'nokogiri'
require 'date'

require_relative 'paths.rb'

def uploadArtefacts(settings)
  
  uploadPlist       settings
  uploadIPA         settings
  uploadChangelog   settings
  
end

def uploadFiles(settings , destination , files_to_upload)
  
  host    = destination["host"]
  login   = destination["login"]
  path    = destination["path"]
  
  if (destination["protocol"] == "ssh")
    uploadViaSSH(host , login , path, files_to_upload)

  elsif (destination["protocol"] == "ftp")
    password = destination["password"]
    uploadViaFTP(host , login , password, path, files_to_upload)

  else 
    puts "Protocole de téléversement inconnu"

  end
  
end

def uploadIPA(settings)

  settings[:deploy]["uploadServer"]["ipa"].each do |destination|
    
    ipaPath         = ipaPath (settings)
    remoteIpaPath   = remoteIpaPath (settings , destination)
    
    dsymPath        = zippedDsymPath(settings)
    remoteDsymPath  = remoteDsymPath(settings , destination)
    
    files_to_upload = [[ipaPath , remoteIpaPath] , [dsymPath , remoteDsymPath]]
    
    uploadFiles(settings , destination , files_to_upload)
    
  end
  
end

def uploadPlist(settings)
  
  settings[:deploy]["uploadServer"]["plist"].each do |destination|
    
    deployPlistPath         = deployPlistPath       (settings)
    remoteDeployPlistPath   = remoteDeployPlistPath (settings , destination)
    
    files_to_upload = [[deployPlistPath , remoteDeployPlistPath]]
    
    uploadFiles(settings , destination , files_to_upload)
    
  end
  
end

def uploadChangelog(settings)
  
  settings[:deploy]["uploadServer"]["plist"].each do |destination|
    
    changelogPath         = changelogPath       (settings)
    remoteChangelogPath   = remoteChangelogPath (settings , destination)
    
    files_to_upload = [[changelogPath , remoteChangelogPath]]
    
    uploadFiles(settings , destination , files_to_upload)
    
  end
  
end

# files_to_upload is an array of arrays
# that must be like [local_file_path , remote_file_path]
def uploadViaSSH(host , login , path, files_to_upload)

  # on vérifie si le dossier existe
  check_command = "if [ ! -d \"#{path}\" ]; then mkdir \"#{path}\"; fi"
  
  Net::SSH.start(host, login) do |ssh|
    # capture all stderr and stdout output from a remote process
    output = ssh.exec!(check_command)
    
    puts "check: #{check_command}"
    puts "output : #{output}"
  end

  Net::SCP.start(host, login) do |scp|
    files_to_upload.each do |names|
      puts 'Envoi du fichier ' + names[0] + ' vers ' + names[1]
      scp.upload!(names[0].to_s, names[1])
    end
  end

end

def checkPathOnFTP(host, usermame , password , path)
  
  folders = path.split("/")
  
  count = 0

  begin
    ftp = Net::FTP.new(host)
    ftp.login(usermame , password)
  rescue Errno::ECONNRESET => e
    count += 1
    retry unless count > 10
    puts "tried 10 times and couldn't get #{url}: #{e}"
  end
  
  createFolders(ftp , folders)
  
  ftp.close
  
end

def createFolders(ftp_connection , folders)
  
  if folders.length < 2
    return
  end
  
  ftp_connection.chdir(folders[0])
  liste = ftp_connection.list
  
  if ! (liste.any? { |element| element.include? folders[1]} )
    ftp_connection.mkdir(folders[1])
  end
  
  createFolders(ftp_connection , folders.slice(1 , folders.length - 1))
  
end


# files_to_upload is an array of arrays
# that must be like [local_file_path , remote_file_path]
def uploadViaFTP(host, usermame , password , path, files_to_upload)
  
  checkPathOnFTP(host, usermame , password , path)
  
  # on est sûr d'avoir le dossier qu'il faut
  # on fait la vraie connexion
  
  ftp = Net::FTP.new(host)
  
  ftp.login(usermame , password)
  
  # ftp.chdir(path)
  
  files_to_upload.each do |names|
    puts "host: #{host}"
    puts 'Envoi du fichier ' + names[0] + ' vers ' + names[1]
    ftp.putbinaryfile(names[0].to_s, names[1])
  end
  
  ftp.close
  
end

