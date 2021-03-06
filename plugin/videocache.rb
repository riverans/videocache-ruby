#
# (C) Copyright Kulbir Saini <saini@saini.co.in>
# Product Website : http://cachevideos.com/
#

require File.expand_path('../../config/application', __FILE__)
require File.expand_path('../videocache/url_rewriter', __FILE__)
require File.expand_path('../videocache/website', __FILE__)

module Videocache
  class UrlRewriter
    include ::Videocache::Website
  end
end

Videocache::UrlRewriter.new.run! if __FILE__ == $0
