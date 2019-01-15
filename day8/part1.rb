numbers = ARGF.read.chomp.split(" ").map(&:to_i)

iter = numbers.each

def parse(iter)
  sum = 0
  child_node_quantity = iter.next
  metadata_quantity = iter.next
  child_node_quantity.times do
    sum += parse(iter)
  end
  metadata_quantity.times do
    sum += iter.next
  end
  return sum
end

puts parse(iter)
