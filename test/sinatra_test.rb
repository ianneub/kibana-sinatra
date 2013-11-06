ENV['RACK_ENV'] = 'test'

require 'kibana/sinatra'
require 'test/unit'
require 'rack/test'

class SinatraTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Kibana::Sinatra::Web
  end

  def test_it_outputs_dashboard
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('{{dashboard.current.title}}')
  end

  def test_it_renders_config_with_default_elasticsearch_url
    get '/config.js'
    assert last_response.ok?
    assert last_response.body.include?('elasticsearch: "http://"+window.location.hostname+":9200"')
  end

  def test_it_renders_config_with_custom_elasticsearch_url
    elasticsearch_url = Proc.new { "http://asdf.com:9200" }

    monkey_patch "elasticsearch_url", elasticsearch_url do
      get '/config.js'
      assert last_response.ok?
      assert last_response.body.include?('elasticsearch: "http://asdf.com:9200"')
    end
  end

  def test_it_renders_config_with_default_kibana_index
    get '/config.js'
    assert last_response.ok?
    assert last_response.body.include?('kibana_index: "kibana-int"')
  end

  def test_it_renders_config_with_custom_kibana_index
    kibana_index = Proc.new { "asdf" }

    monkey_patch "kibana_index", kibana_index do
      get '/config.js'
      assert last_response.ok?
      assert last_response.body.include?('kibana_index: "asdf"')
    end
  end

  def monkey_patch(method_name, method_replacement)
    Kibana::Sinatra::Web.class_eval do
      alias_method "old_#{method_name}", method_name
      define_method method_name, method_replacement
    end
    
    yield

    Kibana::Sinatra::Web.class_eval do
      alias_method method_name, "old_#{method_name}"
      remove_method "old_#{method_name}"
    end
  end
end
