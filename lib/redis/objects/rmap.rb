require 'active_support/concern'
require 'redis/objects'
require 'pry'

class Redis
  module Objects
    module RMap extend ActiveSupport::Concern
      included do
        include Redis::Objects

        class << self; attr_accessor :rmap_options; end
        value :rmap_storage, :global => true, :marshal => true

        after_save do
          self.class.rmap_clear
        end

        after_destroy do
          self.class.rmap_clear
        end
      end

      module ClassMethods
        def has_rmap(title=nil, id=nil)
          options = {
            :title => title,
            :id    => id || :id
          }.with_indifferent_access

          raise "title can not be blank" if options[:title].blank?

          self.rmap_options = {}.with_indifferent_access

          %w(id title).each do |x|
            if options[x].is_a?(Hash)
              self.rmap_options["#{x}_field"] = options[x].keys[0].to_sym
              self.rmap_options["#{x}_proc"]  = options[x].values[0]
            else
              self.rmap_options["#{x}_field"] = options[x].to_sym
              self.rmap_options["#{x}_proc"]  = nil
            end
          end
        end

        def rmap_cache
          models = self.select([rmap_options[:id_field], rmap_options[:title_field]]).map do |a|
            data = []

            %w(id title).each do |x|
              value = a.send(rmap_options["#{x}_field"])
              value = rmap_options["#{x}_proc"].call(value) unless rmap_options["#{x}_proc"].blank?

              data << value
            end

            data
          end

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