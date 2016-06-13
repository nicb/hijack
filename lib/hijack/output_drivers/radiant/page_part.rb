module Hijack

  module OutputDrivers

    module Radiant

      class PagePart < Base

        validates :name, presence: true

        belongs_to :page

      end

    end

  end

end
