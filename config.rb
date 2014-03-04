###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  blog.permalink = ":title.html"
  blog.sources = "posts/:year-:month-:day-:title.html"
  blog.layout = "post"
  blog.summary_separator = /(READMORE)/
  blog.summary_length = 300
  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"
  blog.paginate = true
end

page "/feed.xml", :layout => false

ignore "tag_feed.xml"
ready do
  sitemap.resources.map { |p| p.data["tags"] }.flatten.compact.uniq.map(&:parameterize).map do |tag|
    proxy "/tags/#{tag}.xml", "tag_feed.xml", :layout => false, :locals => { :tag => tag }
  end
end
activate :directory_indexes

set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true
activate :syntax, line_numbers: false

###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end
#


###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
 helpers do
   def author(page_data = current_page.data)
     data.people[page_data.author]
   end
 end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

activate :deploy do |deploy|
  deploy.method = :git
  deploy.remote = 'origin'
  deploy.branch = 'gh-pages'
  deploy.strategy = :force_push
end
