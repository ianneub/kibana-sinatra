ENV['RACK_ENV'] = 'test'

require 'kibana/sinatra'
require 'minitest/autorun'
require 'rack/test'

class SinatraTest < Minitest::Unit::TestCase
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

  def test_it_renders_config_with_default_default_route
    get '/config.js'
    assert last_response.ok?
    assert last_response.body.include?('default_route     : \'/dashboard/file/default.json\'')
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

  def test_it_renders_config_with_custom_default_route
    default_route = Proc.new { "asdf" }

    monkey_patch "default_route", default_route do
      get '/config.js'
      assert last_response.ok?
      assert last_response.body.include?('default_route     : \'asdf\'')
    end
  end

  def test_it_renders_kibana_builtin_dashboard
    get '/app/dashboards/default.json'
    assert last_response.ok?
    assert_equal 4140, last_response.body.length
  end

  def test_it_renders_kibana_builtin_dashboard_when_custom_present
    render_dashboard = Proc.new {|name| "asdf" }

    monkey_patch "render_dashboard", render_dashboard do
      get '/app/dashboards/default.json'
      assert last_response.ok?
      assert_equal 4140, last_response.body.length
    end
  end

  def test_it_renders_default_dashboard
    get '/app/dashboards/asdf.json'
    assert last_response.not_found?
    assert_equal 0, last_response.body.length
  end

  def test_it_renders_custom_dashboard
    render_dashboard = Proc.new {|name| "asdf" }

    monkey_patch "render_dashboard", render_dashboard do
      get '/app/dashboards/testing.json'
      assert last_response.ok?
      assert_equal "asdf", last_response.body
    end
  end

  def monkey_patch(method_name, method_replacement)
    Kibana::Sinatra::Web.class_eval do
      alias_method "original_#{method_name}", method_name
      define_method method_name, method_replacement
    end
    
    yield
  ensure
    Kibana::Sinatra::Web.class_eval do
      alias_method method_name, "original_#{method_name}"
      remove_method "original_#{method_name}"
    end
  end
end
