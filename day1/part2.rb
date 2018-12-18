require "set"
frequencies = ARGF.readlines.map(&:to_i)

current = 0
seen = Set.new

frequencies.cycle do |frequency|
  current += frequency
  if seen.include?(current)
    puts current
    exit
  end
  seen << current
end
