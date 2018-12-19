chars = ARGF.read.chomp.chars

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
    puts chars.size
    # it's not 11752
    exit
  end
  res = ""
  prev = ""
end

