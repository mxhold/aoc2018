fabric = Array.new(1000) { Array.new(1000) { Array.new } }
regex = /^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/

ARGF.readlines.each do |line|
  matchdata = regex.match(line)
  claim_number = matchdata[1].to_i
  left = matchdata[2].to_i
  top = matchdata[3].to_i
  width = matchdata[4].to_i
  height = matchdata[5].to_i

  xmin = left
  xmax = left + width - 1
  ymin = top
  ymax = top + height - 1
  
  (xmin..xmax).each do |x|
    (ymin..ymax).each do |y|
      fabric[y][x].push(claim_number)
    end
  end
end

overlaps = 0

fabric.each do |line|
  line.each do |c|
    if c.length >= 2
      overlaps += 1
    end
  end
end

puts overlaps

