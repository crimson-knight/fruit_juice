module FruitJuiceHash
  refine Hash do
    def deep_stringify_keys!
      deep_transform_keys(&:to_s) 
    end

    def deep_transform_keys(&block)
      _deep_transform_keys_in_object!(self, &block)
    end

    def _deep_transform_keys_in_object!(object, &block)
      case object
      when Hash
        object.keys.each do |key|
          value = object.delete(key)
          object[yield(key)] = _deep_transform_keys_in_object!(value, &block)
        end
        object
      else
        object
      end
    end
  end
end
