require "set"
points = ARGF.readlines.map do |line|
  line.chomp.split(", ").map(&:to_i)
end

grid = Array.new(358) { Array.new(358) }

def distance(from, to)
  (from[0] - to[0]).abs + (from[1] - to[1]).abs
end

size = 0

grid.each_with_index do |line, x|
  line.each_with_index do |cell, y|
    sum = points.sum do |point|
      distance([x, y], point)
    end

    if sum < 10000
      size += 1
    end
  end
end

p size
