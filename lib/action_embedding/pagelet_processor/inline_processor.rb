module ActionEmbedding
  class PageletProcessor
    class InlineProcessor
      def initialize(path, opts = {})
        @path = path
        @opts = opts
      end
      
      def process
        if ActionController::Routing::Routes.respond_to?(:call)
          # Rails 2.3 version
          ActionController::Routing::Routes.call(rack_env)[2]
        else
          puts @opts
          puts rack_env

          # Rails 2.2 version
          request = EmbeddedRequest.new(rack_env)
          response = EmbeddedResponse.new
          
          controller = ActionController::Routing::Routes.recognize(request)
          controller.process(request, response)
          
          response.body
        end
      end
      
      private
      
      def rack_env
        # See http://rack.rubyforge.org/doc/SPEC.html for what needs to
        # go into a Rack environment hash.
        env = {
          'REQUEST_METHOD' => 'GET',
          'SCRIPT_NAME' => '',
          'PATH_INFO' => @path,
          'QUERY_STRING' => '',
          'SERVER_NAME' => 'www.example.com',
          'SERVER_PORT' => 80,
          'rack.version' => [1, 1],
          'rack.url_scheme' => 'http',
          'rack.input' => '',
          'rack.errors' => $stderr,
          'rack.multithread' => false,
          'rack.multiprocess' => false,
          'rack.run_once' => false,
          'rack.session' => @opts[:inline_session] || {},
          'HTTP_COOKIE' => @opts[:inline_cookie]
        }
        
        env['HTTP_X_REQUESTED_WITH'] = 'XMLHttpRequest' if @opts[:send_xhr_header]
        
        env
      end
    end
  end
end