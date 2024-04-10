require 'date'

def bail(msg)
  puts msg
  exit 1
end

days_duration = ARGV[0].to_i
start_date = Date.today
bail 'Duration must > 0' if days_duration == 0

HOLIDAYS_AND_TEAM_DAYS = [
  Date.new(2024,5,6),
  Date.new(2024,5,15),
  Date.new(2024,5,27)
]

date = nil
inc = 1
while days_duration > 0 do
  date = (start_date + inc)
  days_duration -= 1 if [1,2,3,4].include?(date.wday) && !HOLIDAYS_AND_TEAM_DAYS.include?(date)
  inc += 1
end

puts date.strftime("%Y-%m-%d, %a")