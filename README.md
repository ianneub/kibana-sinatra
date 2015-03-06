# Kibana::Sinatra

[![Dependency Status](https://gemnasium.com/ianneub/kibana-sinatra.png)](https://gemnasium.com/ianneub/kibana-sinatra)
[![Build Status](https://travis-ci.org/ianneub/kibana-sinatra.png)](https://travis-ci.org/ianneub/kibana-sinatra)
[![Gem Version](https://badge.fury.io/rb/kibana-sinatra.png)](http://badge.fury.io/rb/kibana-sinatra)

This gem provides [Kibana 3](https://github.com/elasticsearch/kibana) inside a [Sinatra](http://www.sinatrarb.com/) app that you can include in any [Rack](https://github.com/rack/rack) based system, including [Rails](http://www.rubyonrails.org/).

## Deprecation Notice

With the release of Kibana 4, I believe this gem should now be considered depricated. Kibana 4 requires that a server be running in the backend in order for the front end JS to work. At this time I am not sure how feasable it is to wrap up that server in a Sinatra or a Rack app. Perhaps the folks at [kibana-rack](https://github.com/tabolario/kibana-rack) will update and handle it? In the meantime I have been running the app inside a Docker container: [marcbachmann/kibana4](https://registry.hub.docker.com/u/marcbachmann/kibana4/)

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

Create a new file in `config/initializers` and include the following code. Replace the strings with the location of your elasticsearch cluster and the kibana index. You may also set the default_route. Note that all of these are optional. Please refer to the [Kibana config file](https://github.com/elasticsearch/kibana/blob/master/src/config.js) for explanations of what these settings do.

```ruby
module Kibana::Sinatra
  class Web
    def elasticsearch_url
      "http://\"+window.location.hostname+\":9200"
    end

    def kibana_index
      "kibana-int"
    end

    def default_route
      "/dashboard/elasticsearch/asdf"
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

### Custom dashboards

If you would like to include custom dashboard JSON files you can do so by overriding the `render_dashboard(name)` method. This method requires a single parameter `name` that will contain the filename requested. For example, if the browser requests `/app/dashboards/test.json`, then `test.json` will be assigned to the `name` parameter.

This method should return the JSON as a string.

You could then make that JSON file the default by overriding `default_route`.

Here is a full example:

```ruby
module Kibana::Sinatra
  class Web

    def render_dashboard(name)
      case name
      when "test.json"
        "{}"
      when "asdf.json"
        {}.to_json
      end
    end

    def default_route
      "/dashboard/file/test.json"
    end
  end
end
```

Please note there are some [built in dashboard](https://github.com/ianneub/kibana-sinatra/tree/master/lib/kibana/assets/app/dashboards) files that you will **NOT** be able to override.

## Versions

Kibana-sinatra's version number will match the upstream Kibana version number, plus an additional build number. For example:

Kibana-sinatra v.`3.0.0.0` is equivalent to upstream Kibana v.`3.0.0`, and is our build `0`.

We aim to keep in step with Kibana's released versions.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

Thanks for all the help to our [awesome contributors](https://github.com/ianneub/kibana-sinatra/graphs/contributors)!
