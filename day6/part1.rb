require "set"
points = ARGF.readlines.map do |line|
  line.chomp.split(", ").map(&:to_i)
end

grid = Array.new(358) { Array.new(358) }

def distance(from, to)
  (from[0] - to[0]).abs + (from[1] - to[1]).abs
end

grid.each_with_index do |line, x|
  line.each_with_index do |cell, y|
    min_distance = nil
    min_point = nil
    equidistant = false

    points.each do |point|
      distance = distance([x, y], point)

      if min_distance.nil?
        min_distance = distance
        min_point = point
      elsif distance == min_distance
        equidistant = true
      elsif distance < min_distance
        min_distance = distance
        min_point = point
        equidistant = false
      end
    end

    unless equidistant
      grid[x][y] = points.index(min_point)
    end
  end
end

bordering_points = Set.new
(0...358).each do |i|
  bordering_points << grid[0][i]
  bordering_points << grid[357][i]
  bordering_points << grid[i][0]
  bordering_points << grid[i][357]
end

counts = {}
grid.each do |line|
  line.each do |cell|
    unless bordering_points.member?(cell)
      counts[cell] ||= 0
      counts[cell] += 1
    end
  end
end

p counts.max_by { |k,v| v }[1]
