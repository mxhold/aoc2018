# first, sort input with `sort -k1 input.txt > sorted.txt`

regex = /^\[.*:(\d\d)\] (.*)$/
begin_shift_regex = /#(\d+)/

current_guard = nil
from = nil
to = nil

sleeps = {}

ARGF.readlines.each do |line|
  matchdata = regex.match(line)
  minute = matchdata[1].to_i
  description = matchdata[2]

  desc_matchdata = begin_shift_regex.match(description)
  if desc_matchdata
    current_guard = desc_matchdata[1].to_i
    from = nil
    to = nil
  elsif line.include?("falls")
    from = minute
  elsif line.include?("wakes")
    to = minute

    sleeps[current_guard] ||= []
    sleeps[current_guard] << (from...to)
  else
    fail "unreachable"
  end
end

max_minutes_asleep = 0
sleepiest_guard = nil

sleeps.each do |guard, ranges|
  sum = ranges.sum(&:size)
  p sum
  if sum > max_minutes_asleep
    p "!!"
    sleepiest_guard = guard
    max_minutes_asleep = sum
  end
end

p sleeps[sleepiest_guard]
sleep_minutes = sleeps[sleepiest_guard].map(&:to_a).flatten
minute_frequencies = sleep_minutes.reduce(Hash.new(0)) { |h,v| h[v] += 1; h}
puts sleep_minutes.sort_by { |m| minute_frequencies[m] }.last * sleepiest_guard
# it's not 148849 (ah.. it's an exclusive range)
