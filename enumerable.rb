# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum :my_each unless block_given?

    check_self = is_a?(Range) ? to_a : self
    i = 0
    while i < check_self.length
      yield(check_self[i])
      i += 1
    end
  end

  def my_each_with_index
    self.my_each { |i, x| yield  i, x }
  end

  def my_select
    return enum_for :my_select unless block_given?

    Enumerator.new do |y|

      self.my_each { |item| y << item if yield item }
    end.to_a
  end

  def my_all?
    self.my_each { |x| return false unless block_given? ? yield(x) : x }

    true
  end

  def my_any?
    self.my_each { |x| return true if block_given? ? yield(x) : x }

    false
  end

  def my_none?
    self.my_each { |x| return false if block_given? ? yield(x) : x }

    true
  end

  def my_count(item = :NONE)
    is_item = lambda { |x| item == :NONE || item == x }
    is_match = lambda { |x| block_given? ? yield(x) : is_item.call(x) }

    self.my_inject(0) { |count, x| is_match.call (x) ? count + 1 : count }
  end


  def my_map
    return to_enum :my_map unless block_given?

    arr = []
    my_each { |item| arr << yield(item) }
  end

  def my_inject(initial=nil, symbol=nil)
    (initial, symbol = symbol, initial) if NOT block_given? && symbol === nil

    enumera = self.my_each
    result = initial || enumera.next

    loop { result = block_given? ? yield(result, enumera.next) : result.send(symbol, enumera.next) }

    result
  end
end
