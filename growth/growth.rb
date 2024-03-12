raw = 'January	7.90	2.31	7.97	59.07	64.37	11.58	–
February	8.37	2.22	7.92	81.11	49.99	9.48	–
March	10.99	3.58	4.36	123.17	39.24	7.43	–
April	14.17	5.21	1.63	183.52	44.65	8.37	–
May	17.32	7.96	0.20	214.32	49.63	7.96	–
June	20.49	10.80	0.00	218.98	45.28	7.54	–
July	23.13	13.04	0.00	228.10	43.30	7.17	–
August	23.10	13.07	0.00	219.18	56.98	8.13	–
September	19.65	10.74	0.00	162.30	55.26	7.83	–
October	15.45	8.17	0.49	123.66	79.91	11.48	–
November	11.14	5.01	3.07	67.66	74.75	11.17	–
December	8.48	2.67	8.30	56.26	71.91	12.08	–'

def extrap(start, finish, steps)
  raise 'Steps must be at least 2' if steps < 2

  step_change = (finish - start) / (steps - 1).to_f
  out = [start]
  (steps-2).times { |i| out << start + (step_change * (i+1)) }
  out << finish

  out
end

raw_months = raw.split("\n").map { |l| l.split("\t").compact }
month_averages = raw_months.map { |rm| (rm[1].to_f + rm[2].to_f)/2.0 }

week_averages = (0..11).to_a.map do |i|
  next_logical = i == 11 ? 0 : i+1
  step = [2, 5, 8, 11].include?(i) ? 6 : 5
  extrap(month_averages[i], month_averages[next_logical], step).first(step-1)
end.flatten

week_count = week_averages.size
sowings = Array.new(week_count).map { |i| [] }

min_growth_temp = 7.5
required_week_degrees = 30 # Assuming 4 weeks at 15 (15-7.5 x 4)

# Go thru each week we want to harvest
(0..(week_count-1)).to_a.each do |harvest_week|
  sowing_week = harvest_week
  week_degrees = 0

  # Keep retrograding the sowing week until we have enough week degrees
  while week_degrees < required_week_degrees
    temp_this_week = week_averages[sowing_week]
    week_degrees += [temp_this_week - min_growth_temp, 0].max
    sowing_week = (sowing_week - 1) % week_count
  end

  sowings[sowing_week] << harvest_week
end

week_averages.each_with_index do |week, i|
  puts "#{i}: sow for weeks: #{sowings[i]}"
end