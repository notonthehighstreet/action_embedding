module ActionEmbedding
  module Helpers
    def embed_pagelet(path, opts = {})
      raw PageletProcessor.new(path, opts).process
    end
  end
end
