# frozen_string_literal: true

module Enumerable
  def my_each
    i = 0
    while i < check_self.length
      yield check_self[i]
      i += 1
    end
  end

  def my_each_with_index
    my_each { |i, x| yield i, x }
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
    my_each { |item| return true if block_given? ? yield(item) : item }
    false
  end

  def my_none?
    my_each do |item|
      return false if block_given? ? yield(item) : item
    end
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

  def my_inject(initial = nil)
    initial = self[0] if initial.nil?
    first = initial
    my_each { |x| first = yield(first, x) }
    first
  end
end

def multiply_els(arr)
  arr.my_inject(1) { |product, x| product * x }
end
