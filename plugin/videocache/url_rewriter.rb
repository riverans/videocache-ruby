#
# (C) Copyright Kulbir Saini <saini@saini.co.in>
# Product Website : http://cachevideos.com/
#

module Videocache
  class UrlRewriter
    attr_reader :supported_methods, :supported_schemes
    def initialize
      @supported_methods = %w( GET )
      @supported_schemes = %w( http )
      ::App.connect
    end

    def parse_input(input)
      request_id, values = nil, input.strip.scan(/[^ ]+/)
      if values.first.integer?
        request_id = values.first.to_i
        values = values[1..-1]
      end
      return false, request_id if values.size < 4

      url, client_ip_fqdn, user, method = values
      return false, request_id unless valid_uri?(url) and @supported_methods.include?(method.upcase)

      client_ip, fqdn = client_ip_fqdn.split('/')
      return true, request_id, url, client_ip, fqdn, user, method.upcase
    end

    def run!
      ARGF.each_line do |input|
        error(input)
        valid, request_id, url, client_ip, fqdn, user, method = parse_input(input)
        write_back(request_id) and error('invalid') and next unless valid

        if input =~ /.co.in/
          write_back request_id, "302:http://ibnlive.in.com/"
        else
          write_back request_id
        end
      end
    end

    private
    def valid_uri?(url)
      uri = URI.parse(url)
      @supported_schemes.include?(uri.scheme) and uri.host.present?
    rescue
      false
    end

    def write_back(request_id = nil, url = '')
      STDOUT.write "#{request_id} #{url}".squish + "\n"
      STDOUT.flush
      true
    end

    def error(msg = '')
      STDERR.write "#{msg}" + "\n"
      STDERR.flush
      true
    end
  end
end
