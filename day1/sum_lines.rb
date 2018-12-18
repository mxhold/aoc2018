puts(ARGF.readlines.reduce(0) do |sum, line|
  sum += line.to_i
end)
