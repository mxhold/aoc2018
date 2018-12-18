input = ARGF.readlines.map(&:chomp)

result = input.reduce([0, 0]) do |memo, box_id|
  twos, threes = memo
  seen_chars = Hash.new(0)
  box_id.chars.each do |char|
    seen_chars[char] += 1
  end
  if seen_chars.has_value?(2)
    twos += 1
  end
  if seen_chars.has_value?(3)
    threes += 1
  end
  [twos, threes]
end

puts(result[0] * result[1])
