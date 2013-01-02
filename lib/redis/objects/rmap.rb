require 'redis/objects'
require 'pry'

class Redis
  module Objects
    module RMap extend ActiveSupport::Concern
      included do
        include Redis::Objects

        cattr_accessor :rmap_title_field
        value :rmap_storage, :global => true, :marshal => true

        after_save do
          self.class.rmap_clear
        end

        after_destroy do
          self.class.rmap_clear
        end
      end

      module ClassMethods
        def has_rmap(title_field)
          self.rmap_title_field = title_field
        end

        def rmap_cache
          models = self.select([:id, rmap_title_field]).map{|a|
            [a.send(rmap_title_field), a.id.to_s]
          }

          self.rmap_storage = Hash[*models.flatten]
        end

        def rmap_clear
          self.rmap_storage = nil
        end

        def rmap
          rmap_storage.value || rmap_cache
        end
      end
    end
  end
end