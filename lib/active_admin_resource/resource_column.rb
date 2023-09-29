module ActiveAdminResource
  class ResourceColumn
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def type
      :string
    end
  end
end
