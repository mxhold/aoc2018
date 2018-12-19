require "set"

regex = /^Step (.) must be finished before step (.) can begin\.$/
reqs = ARGF.readlines.map do |line|
  matchdata = regex.match(line)
  [matchdata[1], matchdata[2]]
end

class Step
  attr_reader :name
  def initialize(name)
    @done = false
    @name = name
    @deps = Set.new
    @cost = @name.ord - 4
  end

  def ==(other)
    other.name == @name
  end

  def do!
    fail "has deps!" unless doable?
    if @cost == 1
      @done = true
    else
      @cost -= 1
    end
  end

  def done?
    @done
  end

  def doable?
    !done? && (@deps.empty? || @deps.all?(&:done?))
  end

  def add_dep(dep)
    @deps << dep
  end

  def inspect
    "#<Step #{@name} deps=#{@deps.inspect}>"
  end

  def to_s
    "#{@name} (#{@cost})"
  end
end

steps = Hash.new { |hash, key| hash[key] = Step.new(key) }

reqs.each do |dep, step|
  step = steps[step]
  dep = steps[dep]

  step.add_dep(dep)
end

elapsed = 0
workers = []

loop do
  doable_steps = []
  steps.values.each do |step|
    if step.doable?
      doable_steps << step
    end
  end
  if doable_steps.empty?
    # 1062, 1061 is too high
    # 1047 is too low
    # it's also not 1054.....
    puts elapsed
    exit
  end
  available_workers = 5 - workers.size
  current_steps = doable_steps.sort_by { |s| s.name }.reject { |s| workers.include?(s) }.take(available_workers)
  # puts "available: #{current_steps.map(&:to_s).join(", ")}"
  workers += current_steps
  puts elapsed.to_s + " " + workers.map(&:to_s).join(", ")
  new_workers = []
  workers.each do |step|
    step.do!
    unless step.done?
      new_workers << step
    end
  end
  workers = new_workers

  elapsed += 1
end
