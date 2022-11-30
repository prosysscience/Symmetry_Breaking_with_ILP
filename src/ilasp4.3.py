#ilasp_script
ilasp.cdilp.initialise()
solve_result = ilasp.cdilp.solve()

egs = ilasp.all_examples()
egs_gen = [e for e in egs if e[2:6] == '0gen']
egs_wout_gen = [e for e in egs if e[2:6] != '0gen']
ilasp.stats.print_new_iteration()
debug_print('Searching for counterexample...')

c_egs = None
if solve_result is not None:
  c_egs = ilasp.find_all_counterexamples(solve_result)


while c_egs and solve_result is not None:
  conflict_analysis_strategy = {
  'positive-strategy': 'single-ufs-vio-sub',
  'negative-strategy': 'single-as',
  'brave-strategy':    'all-ufs',
  'cautious-strategy': 'single-as-pair'
  }
  ce = ilasp.get_example(c_egs[0]['id'])
  debug_print('Found', ce['type'], 'counterexample:', ce['id'], '(a total of', len(c_egs), 'counterexamples found)')
  if ce['id'][2:6] != '0gen':
    conflict_analysis_strategy['positive-strategy'] = 'single-ufs'
  constraint = ilasp.cdilp.analyse_conflict(solve_result['hypothesis'], ce['id'], conflict_analysis_strategy)

  # An example with recorded penalty of 0 is in reality an example with an
  # infinite penalty, meaning that it must be covered. Constraint propagation is,
  # therefore, unnecessary.
  if not ce['penalty'] == 0:
    c_eg_ids = list(map(lambda x: x['id'], c_egs))
    debug_print('Computed constraint. Now propagating to other examples...')
    prop_egs = []
    if ce['type'] == 'positive':
      prop_egs = ilasp.cdilp.propagate_constraint(constraint, c_eg_ids, {'select-examples': ['positive'], 'strategy': 'cdpi-implies-constraint'})
    elif ce['type'] == 'negative':
      prop_egs = ilasp.cdilp.propagate_constraint(constraint, c_eg_ids, {'select-examples': ['negative'], 'strategy': 'neg-constraint-implies-cdpi'})
    elif ce['type'] == 'brave-order':
      prop_egs = ilasp.cdilp.propagate_constraint(constraint, c_eg_ids, {'select-examples': ['brave-order'],    'strategy': 'cdoe-implies-constraint'})
    else:
      prop_egs = [ce['id']]

    ilasp.cdilp.add_coverage_constraint(constraint, prop_egs)
    debug_print('Constraint propagated to:', prop_egs)

  else:
    ilasp.cdilp.add_coverage_constraint(constraint, [ce['id']])

  solve_result = ilasp.cdilp.solve()

  if solve_result is not None:
    debug_print('Found hypothesis:', solve_result['hypothesis'], solve_result['expected_score'])
    debug_print(ilasp.hypothesis_to_string(solve_result['hypothesis']))
    ilasp.stats.print_new_iteration()
    debug_print('Searching for counterexample...')
    uncovered = solve_result['uncovered']
    solve_result['uncovered'] = uncovered + egs_gen
    # first, check uncovered examples among pos and neg examples derived from S
    c_egs = ilasp.find_all_counterexamples(solve_result)
    # if no uncovered examples, check also "difficult" examples from Gen
    if c_egs == []:
        solve_result['uncovered'] = uncovered + egs_wout_gen
        c_egs = ilasp.find_all_counterexamples(solve_result)


if solve_result:
  print(ilasp.hypothesis_to_string(solve_result['hypothesis']))
else:
  print('UNSATISFIABLE')

ilasp.stats.print_timings()

#end.