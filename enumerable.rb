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

    my_each { |i, x| yield  i, x }
    self

  end

  def my_select
    return enum_for :my_select unless block_given?


    Enumerator.new do |y|
      my_each { |item| y << item if yield item }
    end.to_a
  end

  def my_all?
    my_each { |x| return false unless block_given? ? yield(x) : x }

    true
  end

  def my_any?
    my_each { |x| return true if block_given? ? yield(x) : x }

    false
  end

  def my_none?
    self.my_each { |x| return false if block_given? ? yield(x) : x }

    true
  end

  def my_count(item = nil)
    count = 0
    if block_given?
      my_each { |i| count += 1 if yield(i) == true }
    elsif item.nil?
      my_each { count += 1 }
    else
      my_each { |i| count += 1 if i == item }
    end
    count
  end

  def my_map
    return to_enum :my_map unless block_given?

    arr = []
    my_each { |item| arr << yield(item) }
  end

  def my_inject(*args)
    arr = to_a.dup
    if args[0].nil?
      operand = arr.shift
    elsif args[1].nil? && !block_given?
      symbol = args[0]
      operand = arr.shift
    elsif args[1].nil? && block_given?
      operand = args[0]
    else
      operand = args[0]
      symbol = args[1]
    end

    arr[0..-1].my_each do |i|
      if symbol
        operand = operand.send(symbol, i)
      else
        yield(operand, i)
      end
    end
    operand
  end
end
