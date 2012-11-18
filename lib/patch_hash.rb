class Hash
  def nested_each(&block)
    return Enumerator.new(self, :nested_each) unless block # just in case

    each do |k, v|
      case v
        when Hash  then v.nested_each(&block)
        when Array then v.each { |m| m.nested_each(&block) }
        else block.call(self,k,v) end
    end
  end

  def nested_merge(other_hash, &block)
    dup.nested_merge!(other_hash, &block)
  end

  def nested_merge!(other_hash, &block)
    other_hash.each do |key, value|
      curr_value = self[key]

      next if value.nil? or curr_value.nil?

      if Hash === curr_value and Hash === value
        self[key] = curr_value.nested_merge(value, &block)
      else
        self[key] = block_given? ? yield(key, curr_value, value) : value
      end
    end
    self
  end

  def nested_dup
    duplicate = self.dup

    duplicate.each_pair do |k,v|      
      duplicate[k] = case v
        when Hash  then v.nested_dup
        when Array then v.map(&:nested_dup)
        else            v end
    end

    duplicate
  end
end

