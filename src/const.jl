const GMS_BLOCK_HEADER = ["Variables",
                      "Positive", # Variables
                      "Negative", # Variables
                      "Binary", # Variables
                      "Semicont", #Variables
                      "Integer",
                      "Equations"]

const PROBTYPE = ["LP",      # Linear Programming
                  "QCP",     # Quadratic Constraint Programming
                  "NLP",     # Nonlinear Programming
                  "DNLP",    # Nonlinear Programming with Discontinuous derivatives
                  "MIP",     # Mixed Integer Programming
                  "RMIP",    # Relaxed Mixed Integer Programming
                  "MIQCP",   # Mixed Integer Quadratic Constraint Programming
                  "MINLP",   # Mixed Integer Nonlinear Programming
                  "RMIQCP",  # Relaxed Mixed Integer Quadratic Constraint Programming
                  "RMINLP",  # Relaxed Mixed Integer Nonlinear Programming
                  "MCP",     # Mixed Complementarity Problem
                  "MPEC",	 # Mathematical Program iwth equilibrium Constraints
                  "CNS"		 # Constrained Nonlinear System
				  ]

CPLEX_OBJ_HEAD = [r"MINIMIZE"i, r"MAXIMIZE"i, r"MINIMUM"i, r"MAXIMUM"i, r"MIN"i, r"MAX"i]
CPLEX_CONS_HEAD = [r"subject to"i, r"such that"i, r"st", r"S.T."i, r"ST."i]
CPLEX_BOUND_HEAD = [r"bounds"i, r"bound"i]
CPLEX_END = [r"end"i]
CPLEX_BLOCK_HEAD = [CPLEX_SENSE_HEAD, CPLEX_CONS_HEAD, CPLEX_BOUND_HEAD, CPLEX_END_HEAD, CPLEX_END;]
