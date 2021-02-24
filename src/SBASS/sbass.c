/*
 * sbass.c
 * Symmetry-breaking Answer Set Solving
 *
 * by Christian Drescher <christian.drescher@nicta.com.au>
 *
 * Copyright (C) 2013, National ICT Australia Limited
 * See the LICENSE file for details.
 *
 * This implementation encodes answer set programs as graphs.
 * The symmetries directly found by saucy are used to form
 * symmetry-breaking predicates.
 *
 */

#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "amorph.h"
#include "saucy.h"
#include "platform.h"
#include "util.h"

#define SBASS_VERSION "1.1"
#define INITIAL_ALPHABET_SIZE 262144
#define INITIAL_PROGRAM_SIZE 524288
#define INT_MED INT_MAX/2

struct asp_rule
{
	int	type;
	int*	head;
	int	head_size;
	int*	body;
	int	body_size;
	int	nbody_size;
	int	body_index;
	int	bound;
};

static int max_gen    = 0;
static int max_size   = 0;
static int generators = 0;
static int ignore_mode= 0;
static int stats_mode = 0;
static int show_mode  = 0;
static int orig_vars  = 0;
static int vars       = 0;
static int rules      = 0;
static int max_rules  = 0;
static int num_bounds = 0;
static int max_bounds = 0;
static int col_fact   = 0;
static int col_choice = 0;
static int col_max    = 2;
static int *colors           = NULL;
static int *supp             = NULL;
static int *bounds           = NULL;
static char *marks           = NULL;
static struct asp_rule* prog = NULL;

static int *seen      = NULL;
static int  seen_size = 0;
static int  seen_cert = 1;

static void
arg_gen(char *arg)
{
	max_gen = atoi(arg);
	if (max_gen <= 0)
		die("generator limit must be positive");
}

static void
arg_size(char *arg)
{
	max_size = atoi(arg);
	if (max_size <= 0)
		die("size limit must be positive");
}

static void
arg_ignore(char *arg)
{
	ignore_mode = 1;
}

static void
arg_stats(char *arg)
{
	stats_mode = 1;
}

static void
arg_show(char *arg)
{
	show_mode = 1;
}

static void arg_help(char *arg);

static void
arg_version(char *arg)
{
	printf("sbass %s\n", SBASS_VERSION);
	exit(0);
}

static struct option options[] = {
	{ "limit", 0, "N", arg_gen,
	"limit the number of symmetry group generators" },
	{ "size", 0, "N", arg_size,
	"limit the size of symmetry-breaking constraints" },
	{ "ignore", 0, 0, arg_ignore,
	"ignore unsupported rule types" },
	{ "stats", 0, 0, arg_stats,
	"output statistics" },
	{ "show", 0, 0, arg_show,
	"output symmetry group generators" },
	{ "help", 'h', 0, arg_help,
	"output this help message" },
	{ "version", 'v', 0, arg_version,
	"version information" },
	{ 0, 0, 0, 0, 0 }
};

static void
arg_help(char *arg)
{
	printf("usage: sbass [OPTION]...\n");
	print_options(options);
	exit(0);
}

static __inline__ int
seen_first(int val)
{
	if (val >= seen_size)
	{
		int old_size = seen_size;
		if (seen_size == 0)
		{
			seen_size = INITIAL_ALPHABET_SIZE;
		}
		else do {
			if (seen_size > INT_MED)
			{
				seen_size = INT_MAX;
			}
			else {
				seen_size *= 2;
			}
		}
		while (val >= seen_size);

		seen = realloc(seen, seen_size
				       * sizeof(int));
		if (!seen)
		{
			die("can't reallocate memory");
		}
		memset(seen + old_size, 0, (seen_size - old_size)
				       * sizeof(int));
	}
	return (seen[val] == seen_cert) ? 0 : (seen[val] = seen_cert);
}

static __inline__ void
seen_clear()
{
	if (seen_cert == INT_MAX)
	{
		seen_cert = 1;
		memset(seen, 0, seen_size
				       * sizeof(int));
	}
	else
	{
		seen_cert++;
	}
}

static __inline__ void
seen_reset()
{
	if (seen) {
		free(seen);
	}
	seen      = NULL;
	seen_size = 0;
	seen_cert = 1;
}

struct asp_rule*
add_rule(struct asp_rule rule)
{	
	if (rules == max_rules)
	{
		if (max_rules == 0)
		{
			max_rules = INITIAL_PROGRAM_SIZE;
		}
		else if (max_rules > INT_MED)
		{
			if (max_rules == INT_MAX)
			{	
				die("can't reallocate memory");
			}
			max_rules = INT_MAX;
		}
		else {
			max_rules *= 2;
		}
		
		prog = realloc(prog, max_rules
				       * sizeof(struct asp_rule));
		if (!prog)
		{
			die("can't reallocate memory");
		}
	}
	prog[rules++] = rule;
	return prog;
}

int*
add_bound(int bound)
{	
	if (num_bounds == max_bounds)
	{
		if (max_bounds == 0)
		{
			max_bounds = 2;
		}
		else if (max_bounds > INT_MED)
		{
			max_bounds = INT_MAX;
		}
		else {
			max_bounds *= 2;
		}
		
		bounds = realloc(bounds, max_bounds
				       * sizeof(int));
		if (!bounds)
		{
			die("can't reallocate memory");
		}
	}
	bounds[num_bounds++] = bound;
	return bounds;
}

int
bound_id(int bound)
{
	int i;
	for (i = 0; i < num_bounds; ++i)
	{
		if (bounds[i] == bound)
			return i + 1;
	}
	return 0;
}

void
prog_free(struct asp_rule* prog)
{
	int i;
	for (i = 0; i < rules; ++i)
	{
		free(prog[i].head);
		free(prog[i].body);
	}
	free(prog);
}

/*
 * destructor for graph
 */
void
graph_free(struct amorph_graph* g)
{
	free(g->sg.adj);
	free(g->sg.edg);
	free(g->colors);
	free(g);
}

void
reset_asp_rule(struct asp_rule* r)
{
	r->head = r->body = NULL;
	r->body_index = 0;
	r->head_size = 1;
	r->bound = 0;
}

static __inline__ int
negate(int a)
{
	return a > orig_vars ? a - orig_vars + 1
	                     : a + orig_vars - 1;
}

static __inline__ int
name(int a)
{
	return a > orig_vars ? negate(a) : a;
}

static void
print_rule(int head, int body_size, int nbody_size, ...)
{
	va_list args;
	va_start(args, nbody_size);
	printf("1 %d %d %d", head, body_size, nbody_size);
	while (body_size--)
	{
		printf(" %d", va_arg(args, int));
	}
	putchar('\n');
	va_end(args);
	++rules;
}


/* 
 * generates and prints symmetry-breaking constraints
 */
static int
break_symmetries(int n, const int *perm, int nsupp,
                 int *support, void *arg)
{
	int i, j, k, x, z, ns, big;
	
	/*
	 * ignore bodies and negative literals
	 * exclude most significant atom from each orbit
	 */
	ns = 0;
	for (i = 0; i < nsupp; ++i)
	{
		/* ignore bodies */
		if (support[i] >= 2 * orig_vars) continue;
		
		/* ignore facts */
		if (colors[name(support[i])] == 3) continue;
		
		/* positive literal already marked */
		k = name(support[i]);
		if (marks[k]) continue;
		
		marks[k] = 1;
	
		/* find most significant atom */
		big = k;
		for (j = name(perm[k]); j != k; j = name(perm[j]))
		{
			marks[j] = 1;
			if (big < j) big = j;
		}

		/* exclude lex-biggest atom from each orbit */
		if (k != big)
			supp[ns++] = k;
		for (j = name(perm[k]); j != k; j = name(perm[j]))
		{
			if (j != big)
				supp[ns++] = j;
		}
	}
	
	/* ignore body-only symmetry */
	if (ns == 0) return 1;
	
	/* sort */
	qsort_integers(supp, ns);
	
	/* clean-up */
	for (i = 0; i < nsupp; ++i)
	{
		if (support[i] < 2 * orig_vars)
			marks[name(support[i])] = 0;
	}
	
	/* output symmetries */
	if (show_mode)
	{
		for (i = 0; i < ns; ++i) {
			k = supp[i];
			fprintf(stderr, "(%d", k);
			for (j = perm[k]; j != k; j=perm[j])
			{
				fprintf(stderr, " %d",
				  j <= orig_vars ? j :
				       orig_vars - j - 1);
			}
			fputc(')', stderr);
		}
		fputc('\n', stderr);
	}
	
	/* limit size */
	if (max_size && ns > max_size)
		ns = max_size;

	z = supp[0];
	
	/* print symmetry-breaking constraint */
	print_rule(1, 2, 1, perm[z], z);

	/* additional variable */
	if (1 < ns)
	{
		++vars;
		print_rule(1, 1, 0, vars);
	}

	/* print symmetry-breaking constraints */
	for (i = 1; i < ns; ++i) {
		x = supp[i];

		print_rule(vars, 3, 1, perm[x], x, z);
		print_rule(vars, 3, 2, perm[z], perm[x], x);
		
		if (i < ns - 1)
		{
			print_rule(vars, 2, 0, z, vars+1);
			print_rule(vars, 2, 1, perm[z], vars+1);	
			++vars;
		}
		
		z = x;
	}
	
	/* decrement symmetry generator counter */
	++generators;
	return !max_gen || max_gen-- > 1;
}

/*
 * checks for duplicate edges
 */
static int
dupe_check(int n, int *adj, int *edg)
{
	int i, j, self_loop_ctr;
	int *dupe_tmp = calloc(n, sizeof(int));
	if (!dupe_tmp)
	{
		warn("can't allocate memory");
		free(dupe_tmp);
		return 2;
	}
	
	/* check outgoing edges of each vertex for duplicate */
	for (i = 0; i < n; ++i)
	{
		self_loop_ctr = 0;
		for (j = adj[i] ; j < adj[i+1] ; j++)
		{
			if (edg[j] == i)
			{
				++self_loop_ctr;
				if (self_loop_ctr > 2)
				{
				warn("duplicate in input");
				free(dupe_tmp);
				return 1;
				}
			}
			
			/* duplicate found */
			else if (dupe_tmp[edg[j]] == i+1)
			{
				warn("duplicate in input");
				free(dupe_tmp);
				return 1;
			}
			dupe_tmp[edg[j]] = i+1;
		}
	}

	free(dupe_tmp);
	return 0;
}

/*
 * translates adj values to real locations
 */
static void
init_fixadj1(int n, int *adj)
{
	int val, sum, i;

	val = adj[0]; sum = 0; adj[0] = 0;
	for (i = 1; i < n; ++i)
	{
		sum += val;
		val = adj[i];
		adj[i] = sum;
	}
}

/*
 * translates again-broken sizes to adj values
 */
static void
init_fixadj2(int n, int e, int *adj)
{
	int i;
	for (i = n-1; i > 0; --i)
	{
		adj[i] = adj[i-1];
	}
	adj[0] = 0;
	adj[n] = e;
}

/*
 * reads answer set program from file and generates
 */
struct amorph_graph*
amorph_read_asp(FILE* file)
{
	int a,		/* atoms */
	    b,		/* bodies */
	    e,		/* edges */
	    i, j, k,	/* counter */
	    n,		/* nodes */
	    *aout,	/* adjacency list incoming */
	    *eout,	/* outgoing edges */
	    *ain,	/* adjacency list outgoing */
	    *ein,	/* incoming edges */
	    *nin,	/* adjacency list incoming (negative) */
	    *nout,	/* adjacency list outgoing (negative) */
	    *bout,	/* adjacency list outgoing (body) */
	    *bin,	/* adjacency list incoming (body) */
	    *colors;	/* colorings */
	    
	struct asp_rule active_rule;
	struct amorph_graph* g = NULL;
	
	/* initialization */
	a = 1; b = e = 0;
	aout = eout = colors = NULL;

	/* read rules from smodels-like input */
	while (fscanf(file, "%d", &active_rule.type) == 1)
	{
		/* reset rule container */
		reset_asp_rule(&active_rule);
		
		/*
		 * end of rule input block
		 */
		if (!active_rule.type)
		{
			/* reset set container */
			seen_reset();

			/* initialization */
			orig_vars = vars = a;
			n = 2 * a + b;
			e += a - 1;
		 	g = malloc(sizeof(struct amorph_graph));
			aout = calloc(2 * n + 2, sizeof(int));
			eout = malloc(2 * e * sizeof(int));
			colors = calloc(n, sizeof(int));
			if (!g || !aout || !eout || !colors)
				goto out_free;

			g->sg.n = n;
			g->sg.e = e;
			g->sg.adj = aout;
			g->sg.edg = eout;
			g->colors = colors;
			g->free = graph_free;

			ain = aout + n + 1;
			ein = eout + e;
			nin = ain + a - 1;
			bin = ain + 2 * a - 1;
			bout = aout + 2 * a - 1;
			nout = aout + a - 1;
			
			/* set coloring */
			++colors[0];
			for (i = 2 * a; i < n; ++i)
			{
				++colors[i];
			}
			for (i = a + 1; i < 2 * a; ++i)
			{
				colors[i] = 2;
			}
			
		/*
		 * first pass:
		 * determine size of each adjacency list
		 */
			
		/* boolean consistency edges */
		for (i = 2; i <= a; ++i)
		{
			++aout[i]; ++nin[i];
		}
			
		/* edges through program rules */
		for (i = 0; i < rules; ++i)
		{
			b = prog[i].body_index;
			
			/* update coloring */
			if (prog[i].type == 2)
				colors[2*a - 1 + b] = col_max
				       + bound_id(prog[i].bound);
			else if (prog[i].type == 3)
				colors[2*a - 1 + b] = col_choice;
			
		if (b)
		{	/* (disjunctive) rule */
			bin[b] = prog[i].body_size;
			bout[b] = prog[i].head_size;
			
			for (j = 0; j < prog[i].head_size; ++j)
			{
				++ain[prog[i].head[j]];
			}
			for (j = 0; j < prog[i].nbody_size; ++j)
			{
				++nout[prog[i].body[j]];
			}
			for (; j < prog[i].body_size; ++j)
			{
				++aout[prog[i].body[j]];
			}
		} else if (prog[i].body_size == 1)
		{	/* basic rule with single body literal */
			++ain[prog[i].head[0]];
			
			if (prog[i].nbody_size) {
				++nout[prog[i].body[0]];
			} else {
				++aout[prog[i].body[0]];
			}
		} else if (prog[i].head[0] > 1)
		{	
			/* color facts */
			colors[prog[i].head[0]] = col_fact;
		}
		}
		
		/* fix up */
		init_fixadj1(n, aout);
		init_fixadj1(n, ain);
		
		/*
		 * second pass:
		 * populate edge array
		 */
		
		/* boolean consistency */
		for (i = 2; i <= a; ++i)
		{
			eout[aout[i]++] = a - 1 + i;
			ein[nin[i]++] = i;
		}
		
		/* edges through program rules */
		for (i = 0; i < rules; ++i)
		{
			b = prog[i].body_index;
			k = 2 * a + b - 1;
			
		if (b)
		{	/* (disjunctive) rule */
			for (j = 0; j < prog[i].head_size; ++j)
			{
				eout[bout[b]++]= prog[i].head[j];
				ein[ain[prog[i].head[j]]++] = k;
			}
			for (j = 0; j < prog[i].nbody_size; ++j)
			{
				eout[nout[prog[i].body[j]]++]= k;
				ein[bin[b]++] = a - 1
				               + prog[i].body[j];
			}
			for (; j < prog[i].body_size; ++j)
			{
				eout[aout[prog[i].body[j]]++]= k;
				ein[bin[b]++] = prog[i].body[j];
			}
		} else if (prog[i].body_size == 1)
		{	/* basic rule with single body literal */
			if (prog[i].nbody_size)
			{
				eout[nout[prog[i].body[0]]++] =
				                 prog[i].head[0];
				ein[ain[prog[i].head[0]]++] =
				         a - 1 + prog[i].body[0];
			} else {
				eout[aout[prog[i].body[0]]++] =
				                 prog[i].head[0];
				ein[ain[prog[i].head[0]]++] =
				                 prog[i].body[0];
			}
		}
		}
		
		/* fix up */
		init_fixadj2(n, e, aout);
		init_fixadj2(n, e, ain);

			/* clean-up */
			max_rules = rules;		
			prog_free(prog);
		
			/* check for duplicates	*/
			if (dupe_check(n, aout, eout))
			{	
				g->free(g);
				return NULL;
			}
			
			/* done with graph encoding */
			return g;
		
		} else if (active_rule.type == 1 || 
		           active_rule.type == 2 ||
		           active_rule.type == 3 ||
		                            active_rule.type == 8)
		{
		
		printf("%d", active_rule.type);
		
		/*
		 * read rule from input block
		 */
			
		/* determine head size */
		if (active_rule.type == 3 ||
		                            active_rule.type == 8)
		{
			fscanf(file,"%d", &active_rule.head_size);
			printf(" %d", active_rule.head_size);
			if (active_rule.type == 3 && !col_choice)
				col_choice = ++col_max;
		}
			
		/* read head atoms */
		active_rule.head = malloc(active_rule.head_size
		                                   * sizeof(int));
		if (!active_rule.head) goto out_free;
		seen_clear();
		for (i = 0, j = 0; i < active_rule.head_size; ++i)
		{
			scanf("%d", &active_rule.head[i]);

			/* echo head atom */
			printf(" %d", active_rule.head[i]);
				
			/* check for max atom */
			if (a < active_rule.head[i])
				a = active_rule.head[i];

			/* remove duplicate atoms */
			if (seen_first(active_rule.head[i]))
			{
				active_rule.head[j++] = active_rule.head[i];
			}
		}
		active_rule.head_size = j;
			
		/* determine body size */
		scanf("%d %d", &active_rule.body_size,
		                         &active_rule.nbody_size);

		/* echo body size */
		printf(" %d %d", active_rule.body_size,
		                          active_rule.nbody_size);
		
		/* determine bound */
		if (active_rule.type == 2)
		{
			scanf("%d", &active_rule.bound);
			printf(" %d", active_rule.bound);
			if (!bound_id(active_rule.bound))
				add_bound(active_rule.bound);
		}

		/* read body literals */
		active_rule.body = malloc(active_rule.body_size
		                                   * sizeof(int));
		if (!active_rule.body) goto out_free;

		seen_clear();
		for (i = 0, j = 0; i < active_rule.nbody_size; ++i)
		{
			scanf("%d", &active_rule.body[i]);
			
			/* echo literal */
			printf(" %d", active_rule.body[i]);
				
			/* check for max atom */
			if (a < active_rule.body[i])
				a = active_rule.body[i];

			/* remove duplicate atoms */
			if (seen_first(active_rule.body[i]))
			{
				active_rule.body[j++] = active_rule.body[i];
			}
		}
		active_rule.nbody_size = j;

		seen_clear();
		for (; i < active_rule.body_size; ++i)
		{
			scanf("%d", &active_rule.body[i]);
			
			/* echo literal */
			printf(" %d", active_rule.body[i]);
				
			/* check for max atom */
			if (a < active_rule.body[i])
				a = active_rule.body[i];

			/* remove duplicate atoms */
			if (seen_first(active_rule.body[i]))
			{
				active_rule.body[j++] = active_rule.body[i];
			}
		}
		active_rule.body_size = j;

		if (active_rule.body_size == 1 &&
		                       active_rule.head_size == 1)
		{
			++e;
		} else if (active_rule.body_size)
		{
			e += active_rule.body_size
			                  + active_rule.head_size;
			active_rule.body_index = ++b;
		} else if (active_rule.head_size > 1)
		{
			e += active_rule.head_size;
			active_rule.body_index = ++b;
		} else if (!col_fact)
		{
			col_fact = ++col_max;
		}

		/* add rule to program store */
		if (!add_rule(active_rule)) goto out_free;

		} else {
		
		/*
		 * unsupported rule type
		 */
			warn("unsupported rule type (%d)",
			                        active_rule.type);
			
			if (ignore_mode)
			{
				printf("%d", active_rule.type);
				while ((i = getchar()) != '\n') putchar(i);
			}
			else
			{
				goto out_free;
			}
		}
		
		/* echo end of rule */
		putchar('\n');
	}
	
	reset_asp_rule(&active_rule);
out_free:
	seen_reset();
	free(active_rule.head);
	free(active_rule.body);
	prog_free(prog);
	free(g);
	free(aout);
	free(eout);
	free(colors);
	return NULL;
}

/*
 * entry point
 */
int
main(int argc, char **argv)
{
	struct amorph_graph* g;
	struct saucy *s;
	struct saucy_stats stats;
	char c;
	long cpu_time;

	/* parse command line arguments */
	parse_arguments(&argc, &argv, options);
	if (argc > 0)
		die("trailing arguments");
	
	/* read and echo standard input */
	g = amorph_read_asp(stdin);
	
	if (!g)
		die("unable to read input");
	
	/* allocate memory */
	supp = malloc(g->sg.n * sizeof(int));
	marks = calloc(g->sg.n, sizeof(char));
	if (!marks || !supp)
		bang("can't allocate memory");
	
	s = saucy_alloc(g->sg.n);
	if (!s)
		die("unable to initialize saucy");
		
	colors = g->colors;		
	
	/* detect and break symmetries */
	cpu_time = platform_clock();
	saucy_search(s, &g->sg, 1, g->colors,
	             break_symmetries, 0, &stats);
	cpu_time = platform_clock() - cpu_time;

	/* echo symbol table and compute information */
	putchar('0');
	while ((c = getchar()) != EOF) {
		putchar(c);
	}
	
	/* statistics */
	if (stats_mode) {
		fprintf(stderr, "-------- sbass stats -------\n");
		fprintf(stderr, "nodes      = %d\n", g->sg.n);
		fprintf(stderr, "edges      = %d\n", g->sg.e);
		fprintf(stderr, "generators = %d\n", generators);
		fprintf(stderr, "add. rules = %d\n",
			rules - max_rules);
		fprintf(stderr, "add. atoms = %d\n",
			vars - orig_vars);
		fprintf(stderr, "time       = %.2f\n",
		       divide(cpu_time, PLATFORM_CLOCKS_PER_SEC));
	}
	
	saucy_free(s);
	g->free(g);
	free(marks);
	free(supp);
	
	return EXIT_SUCCESS;
}
