module Hijack

  module Helpers

    module URI

      PROTO_REGEXP = Regexp.compile(/\A(http:\/\/|https:\/\/|ftp:\/\/|mailto:)/)

      def normalize(uri, base)
        res = uri
        res = [base, uri].join('/') unless uri =~ PROTO_REGEXP
        res
      end

      def strip(uri)
        res = nil
        base = nil
        #
        # are we relative or absolute?
        #
        if uri =~ PROTO_REGEXP
          suri = uri.sub(PROTO_REGEXP, '')
          idx_off = uri.size - suri.size
          p = suri.index('/')
          #
          # if p is nil or p is at EOS it means that either the uri ends with a
          # slash or it has no slash and no following link so we should simply
          # return an empty string
          #
          if p && p != (suri.size - 1)
            res = suri[p+1..-1]
            base = uri[0..idx_off+p-1]
          else
            res = ''
            base = uri
          end
        else
          res = uri
          base = ''
        end
        [ res, base ]
      end

      def same_base?(uri0, uri1)
        (rest, base0) = strip(uri0)
        (rest, base1) = strip(uri1)
        base0 == base1
      end

      def relative?(uri)
        (rest, base) = strip(uri)
        base.empty?
      end

    end

  end

end
