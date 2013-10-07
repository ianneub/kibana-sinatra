module Kibana
  module Sinatra

    class Web < ::Sinatra::Base
      set :root, File.expand_path(File.dirname(__FILE__) + "/../../kibana")
      set :public_folder, Proc.new { "#{root}/assets" }
      set :views, Proc.new { "#{root}/views" }

      get '/' do
        File.read("#{settings.public_folder}/index.html")
      end

      get '/config.js' do
        content_type 'text/javascript'
        erb :config
      end

      def self.elasticsearch_url
        "http://\"+window.location.hostname+\":9200"
      end

      def self.kibana_index
        "kibana-int"
      end
    end

  end
end
