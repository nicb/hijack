require 'nokogiri'
require 'erb'

module Hijack

  module OutputDrivers

    module Radiant

      module Extensions

        module Nokogiri

          def to_radiant
            rdizer = Radiantizer.select(self)
            rdizer.to_radiant
          end

        private

          class RawRadiantizer
            attr_reader :accu, :element

            def initialize(el)
              @element = el
              @accu = []
            end

            def to_radiant
              self.radiantize
              self.accu.join
            end

            def radiantize
              _radiantize
            end

          private

            def _radiantize
            end

          end

          class Radiantizer < RawRadiantizer
            attr_accessor :tag, :orig_key, :special_key, :special_value

            def radiantize
              attrs = delete_special_key
              init_accumulator
              accumulate_other_values(attrs)
              extend_to_children
              close
            end

            def text
              self.element.text || ''
            end

            def children
              self.element.children
            end

            class << self

              def select(el)
                res = case el.name
                  when 'img' then ImageRadiantizer.new(el)
                  when 'a'   then LinkRadiantizer.new(el)
                  when 'text' then TextRadiantizer.new(el)
                  when 'br' then BreakRadiantizer.new(el)
                  else PassThroughRadiantizer.new(el)
                end
                res
              end

            end

          private

            def specialize
               self.special_value = self.element[self.special_key].radiantize
            end

            def delete_special_key
              attrs = self.element.attributes.dup
              attrs.delete(self.special_key)
              attrs
            end

            def init_accumulator
               self.accu << "<#{self.tag} name=\"#{self.special_value}\" "
            end

            def accumulate_other_values(attrs)
              attrs.values.each { |nv| self.accu << "#{nv.name}=\"#{nv.value}\" " }
              self.accu << '>'
            end

            def extend_to_children
              self.children.each { |c| self.accu << c.to_radiant }
            end

            def close
              self.accu << "</#{self.tag}>"
            end

          end

          class ImageRadiantizer < Radiantizer

             def initialize(el)
               super
               self.tag = 'r:assets:image'
               self.orig_key = 'img'
               self.special_key = 'src'
               specialize
             end


          end

          class LinkRadiantizer < Radiantizer

             def initialize(el)
               super
               self.tag = 'r:link'
               self.orig_key = 'a'
               self.special_key = 'href'
               specialize
             end

          end

          class TextRadiantizer < RawRadiantizer

            include ERB::Util

          private

            def _radiantize
              self.accu << h(self.element.text)
            end

          end

          class BreakRadiantizer < RawRadiantizer

          private

            def _radiantize
              self.accu << '<br />'
            end

          end

          class PassThroughRadiantizer < Radiantizer

             def initialize(el)
               super
               self.tag = el.name
             end

          private

            def delete_special_key
              self.element.attributes
            end

            def init_accumulator
               self.accu << "<#{self.tag} "
            end

          end

        end

      end

    end

  end

end

class Nokogiri::XML::Node

  include Hijack::OutputDrivers::Radiant::Extensions::Nokogiri

end

class Nokogiri::XML::NodeSet

  def to_radiant(*args)
    self.map { |x| x.to_radiant(*args) }.join
  end

end
