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
  end

  def ==(other)
    other.name == @name
  end

  def do!
    fail "has deps!" unless doable?
    @done = true
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
end

steps = Hash.new { |hash, key| hash[key] = Step.new(key) }

reqs.each do |dep, step|
  step = steps[step]
  dep = steps[dep]

  step.add_dep(dep)
end

result = ""

loop do
  doable_steps = []
  steps.values.each do |step|
    if step.doable?
      doable_steps << step
    end
  end
  if doable_steps.empty?
    puts result
    exit
  end
  current_step = doable_steps.sort_by { |s| s.name }.first
  puts current_step.name
  current_step.do!
  result << current_step.name
end
