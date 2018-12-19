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
    sleeps[current_guard] << (from...to).to_a
  else
    fail "unreachable"
  end
end

minutes = {}

sleeps.each do |guard, guard_minutes|
  guard_minutes.flatten.each do |minute|
    minutes[minute] ||= {}
    minutes[minute][guard] ||= 0
    minutes[minute][guard] += 1
  end
end


max_minute = nil
max_guard = nil
max_freq = 0

minutes.each do |minute, guard_frequencies|
  guard_frequencies.each do |guard, freq|
    if freq > max_freq
      max_minute = minute
      max_guard = guard
      max_freq = freq
    end
  end
end

puts max_minute * max_guard
