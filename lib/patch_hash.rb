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

  # def nested_dup
  #   duplicate = self.dup
  #   duplicate.each_pair do |k,v|
  #     dv = duplicate[k]
      
  #     if Hash === dv and Hash === v
  #       duplicate[k] = dv.nested_dup
  #     elsif Array === dv and Array === v
  #       duplicate[k] = dv.map { |m| m.nested_dup }
  #     else
  #       duplicate[k] = v
  #     end
  #   end
  #   duplicate
  # end

  def nested_dup
    duplicate = self.dup
    duplicate.each_pair do |k,v|      
      if Hash === v
        duplicate[k] = v.nested_dup
      elsif Array === v
        duplicate[k] = v.map { |m| m.nested_dup }
      else
        duplicate[k] = v
      end
    end
    duplicate
  end

end

