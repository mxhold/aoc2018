input = ARGF.read.chomp

def react(input)
  chars = input.chars
  res = ""
  prev = ""

  loop do
    chars.each do |c|
      if c.upcase == prev.upcase && c.downcase == prev.downcase && c != prev
        res.chop!
        prev = res[-1] || ""
      else
        res << c
        prev = c
      end
    end
    prev_chars = chars
    chars = res.chars
    if prev_chars == chars
      return chars
    end
    res = ""
    prev = ""
  end
end

lengths = {}

("a".."z").each do |letter|
  lengths[letter] = react(input.gsub(/#{letter}/i, "")).size
end

p lengths

puts lengths.min_by { |letter, length| length }.last
