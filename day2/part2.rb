input = ARGF.readlines.map(&:chomp)

seen = []

input.each do |box_id|
  seen.each do |seen_id|
    diffs = 0
    common = []
    box_id.chars.zip(seen_id.chars).each do |c1, c2|
      if c1 == c2
        common << c1
      else
        diffs += 1
      end
    end
    if diffs == 1
      puts common.join
      exit
    end
  end
  seen << box_id
end

