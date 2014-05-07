require 'fileutils'
require 'open-uri'
require 'uuid'
require 'zip'

desc "Update kibana from upstream"
task :update do
  raise "You must set the KIBANA_VERSION environment variable." unless ENV['KIBANA_VERSION']

  asset_path = File.expand_path(File.dirname(__FILE__) + "/../kibana/assets")
  download_url = "https://github.com/elasticsearch/kibana/archive/v#{ENV['KIBANA_VERSION']}.zip"
  download_file = "/tmp/#{UUID.new.generate}_#{ENV['KIBANA_VERSION']}.zip"
  tmp_path = "/tmp/#{UUID.new.generate}"
  
  # Remove kibana assets
  FileUtils.rm_rf(asset_path)

  # Create the tmp folder
  FileUtils.mkdir(tmp_path)

  # Download kibana from github
  File.open(download_file, "wb") do |file|
    file.write open(download_url).read
  end

  # Unpack zip into tmp folder
  unzip_file download_file, tmp_path

  # Copy src contents to asset folder
  FileUtils.mv "#{tmp_path}/kibana-#{ENV['KIBANA_VERSION']}/src", asset_path

  # Delete tmp folder and downloaded file
  FileUtils.rm_rf(tmp_path)
  FileUtils.rm(download_file)

  # Move the config.js file to the view file and setup erb variables
  config_file = "#{asset_path}/../views/config.erb"
  FileUtils.mv "#{asset_path}/config.js", config_file
  text = File.read(config_file)
  text.gsub!('http://"+window.location.hostname+":9200', '<%= elasticsearch_url %>')
  text.gsub!('"kibana-int"', '"<%= kibana_index %>"')
  File.open(config_file, "w") {|file| file.write(text) }
end

def unzip_file(file, destination)
  Zip::File.open(file) { |zip_file|
   zip_file.each { |f|
     f_path=File.join(destination, f.name)
     FileUtils.mkdir_p(File.dirname(f_path))
     zip_file.extract(f, f_path) unless File.exist?(f_path)
   }
  }
end
