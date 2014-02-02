module Dea
  class ApiModel
    def self.batch_load(array)
      array.map(&method(:new))
    end

    def ==(other)
      self.id == other.id
    end
  end
end
