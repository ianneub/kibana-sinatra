# Kibana::Sinatra

This gem provides [Kibana 3](https://github.com/elasticsearch/kibana) inside a [Sinatra](http://www.sinatrarb.com/) app that you can include in any Rack based system, including Rails.

## Installation

Add this line to your application's Gemfile:

    gem 'kibana-sinatra'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kibana-sinatra

## Usage

### Inside Rails

First you will need to configure Kibana's config.js file so that a web browser can find your [elasticsearch](http://www.elasticsearch.org/) cluster.

Create a new file in `config/initializers` and include the following code. Replace the strings with the location of your elasticsearch cluster and the kibana index. Note that both of these are optional.

```ruby
module Kibana::Sinatra
  class Web
    def self.elasticsearch_url
      "http://\"+window.location.hostname+\":9200"
    end
    
    def self.kibana_index
      "kibana-int"
    end
  end
end
```

In your `config/routes.rb` file mount the Kibana::Sinatra::Web class to a route:

    mount Kibana::Sinatra::Web => '/kibana', :trailing_slash => true
    
The trailing slash is important due to the way Kibana links to CSS & JS files.

Start your server and you should now be able to load `/kibana/` and Kibana 3 should start up!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
