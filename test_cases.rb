require './enumerable'
# rubocop:disable  Metrics/AmbiguousBlockAssociation

puts %w[h i hi hello].each { |element| puts element }
puts %w[h i hi hello].my_each { |element| puts element }

puts %w[h i hi hello].each_with_index { |element, index| puts element + index.to_s }
puts %w[h i hi hello].my_each_with_index { |element, index| puts element + index.to_s }

puts %w[h i hi hello].select { |element| element[0] == 'h' }
puts %w[h i hi hello].my_select { |element| element[0] == 'h' }

puts %w[h i hi hello].all? { |element| element.is_a? String }
puts %w[h i hi hello].my_all? { |element| element.is_a? String }

puts [3, 3, 3, 'hello'].any? { |element| element.is_a? String }
puts [3, 3, 3, 3].my_any? { |element| element.is_a? String }

puts [3, 3, 3, 'hello'].none? { |element| element.is_a? String }
puts [3, 3, 3, 3].my_none? { |element| element.is_a? String }

puts [3, 3, 3, 3].count
puts [3, 3, 3, 3].my_count

# rubocop:disable  Metrics/SymbolProc
puts %w[h i hi hello].map { |element| element.upcase }
puts %w[h i hi hello].my_map { |element| element.upcase }

puts [1, 2, 3, 4].inject(0) { |result, element| result + element }
puts [1, 2, 3, 4].my_inject(0) { |result, element| result + element }

def multiply_els(array)
  array.my_inject(1) { |total, element| total * element }
end

puts multiply_els([2, 4, 5])