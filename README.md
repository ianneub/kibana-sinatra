# Kibana::Sinatra

[![Dependency Status](https://gemnasium.com/ianneub/kibana-sinatra.png)](https://gemnasium.com/ianneub/kibana-sinatra)
[![Build Status](https://travis-ci.org/ianneub/kibana-sinatra.png)](https://travis-ci.org/ianneub/kibana-sinatra)
[![Gem Version](https://badge.fury.io/rb/kibana-sinatra.png)](http://badge.fury.io/rb/kibana-sinatra)

This gem provides [Kibana 3](https://github.com/elasticsearch/kibana) inside a [Sinatra](http://www.sinatrarb.com/) app that you can include in any Rack based system, including Rails.

It is currently based on Kibana 3 commit [0efdd461df712efea6024d9055791d1025c9e1ed](https://github.com/elasticsearch/kibana/commits/0efdd461df712efea6024d9055791d1025c9e1ed)

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
    def elasticsearch_url
      "http://\"+window.location.hostname+\":9200"
    end

    def kibana_index
      "kibana-int"
    end
  end
end
```

In your `config/routes.rb` file mount the Kibana::Sinatra::Web class to a route:

    mount Kibana::Sinatra::Web => '/kibana', :trailing_slash => true

The trailing slash is important due to the way Kibana links to CSS & JS files.

Start your server and you should now be able to load `/kibana/` and Kibana 3 should start up!

### Launch as Rack app

First you will need to configure Kibana's config.js same as "Inside Rails".

And add config.ru on top of your directory.

```ruby
require 'sinatra'
require 'kibana/sinatra/web'

# If you need to configure elasticsearch_url, put your configuration here just like the Rails example.

run Kibana::Sinatra::Web
```

At last, you need to just run rackup.

```
rackup
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

Thanks for all the help to our [awesome contributors](https://github.com/ianneub/kibana-sinatra/graphs/contributors)!
