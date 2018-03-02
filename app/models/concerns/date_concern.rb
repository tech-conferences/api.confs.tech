module DateConcern
  extend ActiveSupport::Concern

  included do
    def self.date_accessor(*args)
      args.each do |attr_name|
        define_method attr_name do
          instance_variable_get("@#{attr_name}")
        end

        define_method "#{attr_name}=" do |value|
          return unless value
          instance_variable_set("@#{attr_name}", Chronic.parse(value).to_i)
        end
      end
    end
  end
end
