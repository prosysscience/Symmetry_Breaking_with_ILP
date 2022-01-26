#ilasp_script
solve_result = ilasp.ilasp2(ilasp.all_examples())


if solve_result:
  print ilasp.hypothesis_to_string(solve_result['hypothesis'])
else:
  print 'UNSATISFIABLE'

ilasp.stats.print_timings()

#end.
