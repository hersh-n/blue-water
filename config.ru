require "rack"
require "rack/contrib/try_static"

# Enable proper HEAD responses
use Rack::Head

# Add basic auth if configured
if ENV["HTTP_USER"] && ENV["HTTP_PASSWORD"]
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    [username, password] == [ENV["HTTP_USER"], ENV["HTTP_PASSWORD"]]
  end
end

# Attempt to serve static HTML files
use Rack::TryStatic,
    :root => "build",
    :urls => %w[/],
    :try => ['.html', 'index.html', '/index.html']

# Serve a 404 page if all else fails
run lambda{ |env|
  four_oh_four_page = File.expand_path("../build/404.html", __FILE__)
  [ 404, { 'Content-Type'  => 'text/html'}, [ File.read(four_oh_four_page) ]]
}