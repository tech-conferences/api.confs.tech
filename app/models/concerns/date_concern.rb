module DateConcern
  extend ActiveSupport::Concern

  included do
    def self.date_accessor(*args)
      args.each do |attr_name|
        define_method "#{attr_name}Unix" do
          Chronic.parse(instance_variable_get("@#{attr_name}")).to_i
        end
      end
    end
  end
end
