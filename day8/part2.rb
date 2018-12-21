numbers = ARGF.read.chomp.split(" ").map(&:to_i)

iter = numbers.each

def parse(iter)
  sum = 0
  child_node_quantity = iter.next
  metadata_quantity = iter.next

  if child_node_quantity == 0
    metadata_quantity.times do
      nextv = iter.next
      sum += nextv
    end
    return sum
  end

  children_results = []

  child_node_quantity.times do
    children_results << parse(iter)
  end

  metadata_quantity.times do
    child_index = iter.next
    child_result = children_results.fetch(child_index - 1, 0)
    sum += child_result
  end

  return sum
end

puts parse(iter)
