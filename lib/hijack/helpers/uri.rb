module Hijack

  module Helpers

    module URI

      PROTO_REGEXP = Regexp.compile(/\A(http:\/\/|https:\/\/|ftp:\/\/)/)

      def normalize(uri, base)
        res = uri
        res = [base, uri].join('/') unless uri =~ PROTO_REGEXP
        res
      end
  
      def strip(uri)
        res = ''
        suri = uri.sub(PROTO_REGEXP, '')
        p = suri.index('/')
        #
        # if p is nil or p is at EOS it means that either the uri ends with a
        # slash or it has no slash and no following link so we should simply
        # return an empty string
        #
        if p && p != (uri.size - 1)
          res = suri[p+1..-1]
        end
        res
      end

    end

  end

end
