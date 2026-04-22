from SLiCAP import *
import control as ct
from scipy.signal import *
from scipy.optimize import least_squares
from scipy.optimize import differential_evolution

sp.init_printing()
prj = initProject("LC ladder synthesis")
instr = instruction()

instr.setCircuit("LC_ladder_series_first_Lossy3.spice")
instr.setSimType("symbolic")
instr.setGainType("gain")
instr.setDataType("laplace")
instr.indepVars()
instr.depVars()
instr.setSource('V1')
instr.setDetector('V_OUT')
res = instr.execute()
Gain_expr = sp.symbols("V_OUT")
print(eqn2TEX( Gain_expr, res.laplace))
sp.simplify(res.laplace)

# BEHAVEIOR MODEL
    
s = sp.symbols('s')
from scipy.signal import *
#[nume, denum] = ellip(5,0.5,35,250e6*2*np.pi,analog=True)
[nume, denum] = ellip(5,0.25,30,1,analog=True)

filter_tf = ct.tf(nume,denum)
filter_tf * 0.5
  
Poles_array = ct.poles(filter_tf)
Zeros_array = ct.zeros(filter_tf)
filter_Gain = 0.5;
Real_pole = Poles_array[-1]
real_pole_tf = ct.tf([-1*Real_pole],[1, -1*Real_pole])
print(real_pole_tf)
#Poles_array_no_real_pole= Poles_array[0:4]
#print(filter_tf/(real_pole_tf))


#filter_tf_no_real_pole=ct.zpk(Zeros_array,Poles_array_no_real_pole,1)
#filter_tf_no_real_pole=filter_tf_no_real_pole/filter_tf_no_real_pole.dcgain() * 0.5
#ct.bode(filter_tf_no_real_pole)
#plt.show()

filter_symbolic = ct_to_sympy(filter_tf*0.5,s)
#filter_symbolic = ct_to_sympy(filter_tf_no_real_pole,s)
FILTER_SYMBOLIC_COEFF_BEHAVE = coeffsTransfer(filter_symbolic)
NUME_BEAHVE= FILTER_SYMBOLIC_COEFF_BEHAVE[1]
DENOM_BAHVE = FILTER_SYMBOLIC_COEFF_BEHAVE[2]
print(DENOM_BAHVE)
print(NUME_BEAHVE)

## Symblic Circuit
s = sp.symbols('s')
RS_value = 1;
RL_value = 1;
RL , RS,RLOSS = sp.symbols('RL RS RLOSS')
RL , RS,QF = sp.symbols('RL RS QF')
#denom = sp.denom(res.laplace)
#nume = sp.numer(res.laplace)


Filter_TF = res.laplace.subs(RL,RL_value)
Filter_TF = Filter_TF.subs(RS,RS_value)
QF_value = 150
RLOSS_value = 1/QF_value
Filter_TF = Filter_TF.subs(RLOSS,RLOSS_value)
Filter_TF = Filter_TF.subs(QF,QF_value)
FILTER_SYMBOLIC_COEFF_CIRCUIT =coeffsTransfer(Filter_TF)

NUME_CIRCUIT = FILTER_SYMBOLIC_COEFF_CIRCUIT[1]
DENOM_CIRCUIT = FILTER_SYMBOLIC_COEFF_CIRCUIT[2]
print(DENOM_CIRCUIT)
print(NUME_CIRCUIT)

FILTER_SYMBOLIC_COEFF_CIRCUIT[1]

#equations = [sp.Eq(sym, num) for sym, num in zip(NUME_CIRCUIT, NUME_BEAHVE)]
#equations2 = [sp.Eq(sym, num) for sym, num in zip(DENOM_CIRCUIT, DENOM_BAHVE)]
Matrix1 = sp.Matrix(NUME_CIRCUIT)
SYM_M = Matrix1.col_join(sp.Matrix(DENOM_CIRCUIT))

Matrix2 = sp.Matrix(NUME_BEAHVE)
BEHAVE_M = Matrix2.col_join(sp.Matrix(DENOM_BAHVE))
L_1 , L_2 , C_2 , L_3, C_4 ,L_4 ,L_5 = sp.symbols('L_1  L_2  C_2  L_3 C_4 L_4 L_5')
#solution = sp.nsolve(SYM_M - BEHAVE_M ,[C_1 , L_2 , C_3 , L_4, C_5 ,C_Z1 , C_Z2],[1 ,1,1,1,1,1,1])
EQUATIONS = SYM_M - BEHAVE_M 
print(EQUATIONS)
filtered_rows = [EQUATIONS.row(i) for i in range(EQUATIONS.rows) if not EQUATIONS.row(i).is_zero_matrix]
filtered_rows
F_clean = sp.Matrix.vstack(*filtered_rows)
F_clean
# 1. Convert SymPy matrix to a numerical function
# We use 'numpy' for speed and stability
func = sp.lambdify(([L_1 , L_2 , C_2 , L_3, C_4 ,L_4 ,L_5],), F_clean, modules='numpy')
active_vars = [L_1 , L_2 , C_2 , L_3, C_4 ,L_4 ,L_5]
# 2. Wrapper to flatten the output for scipy
def f(x):
    return np.array(func(x)).astype(float).flatten()

#X_inital = [0.181 , 0.058 , 0.16 , 0.24 , 0.09 , 0.195 , 0.115]
#solution = fsolve(f, x0=[1]*len(active_vars))

results = least_squares(
    f, 
    x0=[1.0]*7, 
    method='trf',     # 'trf' (Trust Region Reflective) is more precise than 'lm'
    ftol=1e-12,       # Default is 1e-8
    xtol=1e-12,       # Default is 1e-8
    gtol=1e-12,       # Default is 1e-8
    max_nfev=10000     # Allow more iterations to reach this precision
)
results.success
#solution = fsolve(f, x0=X_inital)
solution = results.x
print("Solution:", solution)
active_vars
sol_dict = dict(zip(active_vars, results.x))
for key in sol_dict.keys():
    sol_dict[key]=sol_dict[key]/(250e6*2*np.pi)

sol_dict
F_clean.subs(sol_dict)

final_solution = solution / (250e6*2*np.pi) 
print("Final Solution:", final_solution)

# GM-C impelementation

gm_value = 300e-6;
R_normal = RS_value;
gm2 = gm_value*RS_value / R_normal
gmL = gm_value*R_normal /RL_value
gm_C = np.zeros(7);
gm_C[0] = gm_value * final_solution[0] /R_normal *1e15  # in femto-farad
gm_C[1] = gm_value * final_solution[1] /R_normal *1e15  # in femto-farad
gm_C[2] = gm_value * final_solution[2] *R_normal *1e15  # in femto-farad
gm_C[3] = gm_value * final_solution[3] /R_normal *1e15  # in femto-farad
gm_C[4] = gm_value * final_solution[4] *R_normal *1e15  # in femto-farad
gm_C[5] = gm_value * final_solution[5] /R_normal *1e15  # in femto-farad
gm_C[6] = gm_value * final_solution[6] /R_normal *1e15  # in femto-farad
Component_spread = np.max(gm_C)/np.min(gm_C)
print(Component_spread)
print(np.max(gm_C))

def ct_to_sympy(tf, s=sp.symbols('s')):
    """
    Converts a Python-Control TransferFunction to a SymPy expression.
    Works for SISO (Single-Input Single-Output) systems.
    """
    # Extract coefficients for the first input and output
    num_coeffs = tf.num[0][0]
    den_coeffs = tf.den[0][0]
    
    # Create polynomials from the coefficient lists
    # Note: control package lists are ordered by descending powers of s
    num_poly = sp.Poly(num_coeffs, s).as_expr()
    den_poly = sp.Poly(den_coeffs, s).as_expr()
    return num_poly / den_poly


def get_control_coeffs(expr, sol_dict, s_var):
    """
    Converts a symbolic expression to a list of floats.
    
    Args:
        expr: The SymPy expression (numerator or denominator).
        sol_dict: Dictionary of {Symbol: float} from your solver.
        s_var: The SymPy symbol for Laplace 's'.
    """
    # 1. Substitute the numerical values into the expression
    numerical_expr = expr.subs(sol_dict)
    
    # 2. Fully expand to ensure it's in standard polynomial form
    expanded_expr = sp.expand(numerical_expr)
    
    # 3. Use SymPy Poly to extract all coefficients including zeros
    # 'domain=sp.RR' forces numerical coefficients
    poly = sp.Poly(expanded_expr, s_var, domain=sp.RR)
    
    # 4. Convert SymPy Floats to standard Python floats
    # all_coeffs() returns them in descending order: [s^n, ..., s^1, s^0]
    coeffs = [float(c) for c in poly.all_coeffs()]
    
    return coeffs

# --- Usage Example ---
num_list = get_control_coeffs(sp.numer(Filter_TF), sol_dict, s)
den_list = get_control_coeffs(sp.denom(Filter_TF), sol_dict, s)
sys = ct.TransferFunction(num_list, den_list)

ct.bode(sys,dB=True,Hz=True)
mpl.cursor(multiple=True)

ct.bode(filter_tf,dB=True,Hz=True)
mpl.cursor(multiple=True)

ct.pzmap(sys)
ct.pzmap(filter_tf)
