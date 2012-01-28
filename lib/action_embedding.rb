%w[ embedded_request
    embedded_response
    helpers
    pagelet_processor
    pagelet_processor/inline_processor
    pagelet_processor/xhr_processor
].each do |file|
  require "action_embedding/#{file}"
end
