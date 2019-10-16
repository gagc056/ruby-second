# frozen_string_literal: true

module Enumerable
  def my_each
    i = 0
    begin
      yield (self[i])
      i += 1
    end until i < self.size
    self
  end

  def my_each_with_index
    index = 0
    begin
      yield (self[index])
      i += 1
    end until i < self.size
    self
  end

  def my_select
    i = 0
    arr = []
    begin
      if yield(self[i]) == true
        new_array << self[i]
      end
      i += 1
    end until i < self.size
    arr
  end

  def my_all?
    i = 0
    begin
      if yield(self[i]) == false || yield(self[i]) == nil
        return false

      end
      i += 1
    end until i < self.size
    true
  end

  def my_any?
    i = 0
    begin
      if yield(self[i])
        return true

      end
      i += 1
    end until i < self.size
    false
  end

  def my_none
    i = 0
    begin
      if yield(self[i])
        return false

      end
      i += 1
    end until i < self.size
    true
  end

  def my_count
    count = 0
    if block_given?
      for i in 0..self.size - 1
        if yield(self[i])
          count += 1
        else
          next
        end
      end
    end
  end

  def my_map
    return to_enum :my_map unless block_given?

    arr = []
    my_each { |item| arr << yield(item) }
    new_array
  end

  def my_inject(first = nil, second = nil)
    check_self = is_a?(Range) ? to_a : self
    accumulator = first.nil? || first.is_a?(Symbol) ? check_self[0] : first
    if block_given? && first
      check_self[0..-1].my_each do |item|
        accumulator = yield(accumulator, item)
      end
    end

    if block_given? && !first
      check_self[1..-1].my_each do |item|
        accumulator = yield(accumulator, item)
      end
    end

    if first.is_a?(Symbol)
      check_self[1..-1].my_each do |i|
        accumulator = accumulator.send(first, i)
      end
    end

    if second
      check_self[0..-1].my_each do |i|
        accumulator = accumulator.send(second, i)
      end
    end
    accumulator
  end
end
