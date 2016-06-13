module Hijack

  module OutputDrivers

    module Radiant

      class PageField < Base

        validates :name, presence: true
        validates :page_id, presence: true

        belongs_to :page

      end

    end

  end

end
