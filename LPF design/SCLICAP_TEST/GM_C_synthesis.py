from SLiCAP import *
import control as ct
from scipy.signal import *
from scipy.optimize import least_squares
from scipy.optimize import differential_evolution
import mplcursors as mpl
%matplotlib qt
s = sp.symbols('s')
sp.init_printing()
prj = initProject("GM-C synthesis")
instr = instruction()

instr.setCircuit("GM_C_filter.spice")
instr.setSimType("symbolic")
instr.setGainType("gain")
instr.setDataType("laplace")
instr.indepVars()
instr.depVars()
instr.setSource('V1')
instr.setDetector('V_OUT')
res = instr.execute()
#Gain_expr = sp.symbols("V_OUT")
#print(eqn2TEX( Gain_expr, res.laplace))
sp.simplify(res.laplace)

# BEHAVEIOR MODEL
    
[nume, denum] = ellip(5,0.02,20,1,analog=True)
[nume2, denum2] = ellip(5,0.1,25,2*np.pi*250e6,analog=True)


filter_tf = ct.tf(nume,denum)
filter_tf2 = ct.tf(nume2,denum2)

#ct.bode(filter_tf2,dB=True,Hz=True)
#mpl.cursor(multiple=True)
  

Poles_array = ct.poles(filter_tf)
Zeros_array = ct.zeros(filter_tf)
filter_Gain = 0.5;
filter_symbolic = ct_to_sympy(filter_tf*0.5,s)
FILTER_SYMBOLIC_COEFF_BEHAVE = coeffsTransfer(filter_symbolic)
NUME_BEAHVE= FILTER_SYMBOLIC_COEFF_BEHAVE[1]
DENOM_BAHVE = FILTER_SYMBOLIC_COEFF_BEHAVE[2]
print(DENOM_BAHVE)
print(NUME_BEAHVE)

## Symblic Circuit
#RS_value = 1;
#RL_value = 1;
gm_value = 1;
gm_1 = sp.symbols('gm_1')
RO1 = sp.symbols('RO1')
#RL , RS,RLOSS = sp.symbols('RL RS RLOSS')
#RL , RS,QF = sp.symbols('RL RS QF')
#denom = sp.denom(res.laplace)
#nume = sp.numer(res.laplace)


#Filter_TF = res.laplace.subs(RL,RL_value)
#Filter_TF = Filter_TF.subs(RS,RS_value)
QF_value = 150
RO_value = QF_value/gm_value
#Filter_TF = Filter_TF.subs(RLOSS,RLOSS_value)
#Filter_TF = Filter_TF.subs(QF,QF_value)
Filter_TF = res.laplace.subs([(gm_1,gm_value),(RO1,RO_value)])
FILTER_SYMBOLIC_COEFF_CIRCUIT =coeffsTransfer(Filter_TF)

NUME_CIRCUIT = FILTER_SYMBOLIC_COEFF_CIRCUIT[1]
DENOM_CIRCUIT = FILTER_SYMBOLIC_COEFF_CIRCUIT[2]
#print(DENOM_CIRCUIT)
#print(NUME_CIRCUIT)

#FILTER_SYMBOLIC_COEFF_CIRCUIT[1]

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
    ftol=1e-15,       # Default is 1e-8
    xtol=1e-15,       # Default is 1e-8
    gtol=1e-15,       # Default is 1e-8
    max_nfev=2000     # Allow more iterations to reach this precision
)
results.success
#solution = fsolve(f, x0=X_inital)
#solution = results.x
#print("Solution:", solution)
#active_vars
sol_dict = dict(zip(active_vars, results.x))
sol_dict_final = dict()
for key in sol_dict.keys():
    sol_dict_final[key]=sol_dict[key]/(250e6*2*np.pi)

sol_dict
F_clean.subs(sol_dict)

sol_dict_final

# Impelementation
gm_actual_value = 200e-6
sol_dict_final_realization = dict()
for key in sol_dict.keys():
    sol_dict_final_realization[key]=sol_dict_final[key]*gm_actual_value

sol_dict_final_realization
Max_component = np.max(list(sol_dict_final_realization.values()))
Min_component = np.min(list(sol_dict_final_realization.values()))
component_spread = Max_component/Min_component
print(component_spread)
Transfer_Function = res.laplace.subs([(gm_1,gm_actual_value),(RO1,QF_value/gm_actual_value)])

num_list_real = get_control_coeffs(sp.numer(Transfer_Function), sol_dict_final_realization, s)
den_list_real = get_control_coeffs(sp.denom(Transfer_Function), sol_dict_final_realization, s)
Filter_TF_realization_control = ct.tf(num_list_real , den_list_real)

# Testing 
Filter_TF_realization_control
ct.bode(Filter_TF_realization_control,dB=True,Hz=True)
mpl.cursor(multiple=True)

ZEROS 
ZEROs ,ZETAs , POLEs =ct.damp(filter_tf)
1/(2*ZETAs)

#---- Sensitivity ------
SC =np.complex64(0,1)
RESP_at_1  = Filter_TF.subs(s,SC)
RESP_at_1_value = RESP_at_1.subs(sol_dict)
Mag_at_1_value = np.abs(RESP_at_1_value)


Diff_L_1  = sp.diff(RESP_at_1,L_1)
Diff_L_1_value = Diff_L_1.subs(sol_dict)
mag_diff_L_1_value = np.abs(Diff_L_1_value)
S_L_1 = mag_diff_L_1_value/Mag_at_1_value
S_L_1_dB = 20*np.log10(np.float64(S_L_1))
print(S_L_1_dB)

Diff_L_2  = sp.diff(RESP_at_1,L_2)
Diff_L_2_value = Diff_L_2.subs(sol_dict)
mag_diff_L_2_value = np.abs(Diff_L_2_value).evalf()
S_L_2 = np.abs(mag_diff_L_2_value/Mag_at_1_value)
S_L_2_dB = 20*np.log10(np.float64(S_L_2))
print(S_L_2_dB)

Diff_C_2  = sp.diff(RESP_at_1,C_2)
Diff_C_2_value = Diff_C_2.subs(sol_dict)
mag_diff_C_2_value = np.abs(Diff_C_2_value).evalf()
S_C_2 = np.abs(mag_diff_C_2_value/Mag_at_1_value)
S_C_2_dB = 20*np.log10(np.float64(S_C_2))
print(S_C_2_dB)

Diff_L_3  = sp.diff(RESP_at_1,L_3)
Diff_L_3_value = Diff_L_3.subs(sol_dict)
mag_diff_L_3_value = np.abs(Diff_L_3_value).evalf()
S_L_3 = np.abs(mag_diff_L_3_value/Mag_at_1_value)
S_L_3_dB = 20*np.log10(np.float64(S_L_3))
print(S_L_3_dB)

Diff_L_4  = sp.diff(RESP_at_1,L_4)
Diff_L_4_value = Diff_L_4.subs(sol_dict)
mag_diff_L_4_value = np.abs(Diff_L_4_value).evalf()
S_L_4 = np.abs(mag_diff_L_4_value/Mag_at_1_value)
S_L_4_dB = 20*np.log10(np.float64(S_L_4))
print(S_L_4_dB)

Diff_C_4  = sp.diff(RESP_at_1,C_4)
Diff_C_4_value = Diff_C_4.subs(sol_dict)
mag_diff_C_4_value = np.abs(Diff_C_4_value).evalf()
S_C_4 = np.abs(mag_diff_C_4_value/Mag_at_1_value)
S_C_4_dB = 20*np.log10(np.float64(S_C_4))
print(S_C_4_dB)


Diff_L_5  = sp.diff(RESP_at_1,L_5)
Diff_L_5_value = Diff_L_5.subs(sol_dict)
mag_diff_L_5_value = np.abs(Diff_L_5_value).evalf()
S_L_5 = np.abs(mag_diff_L_5_value/Mag_at_1_value)
S_L_5_dB = 20*np.log10(np.float64(S_L_5))
print(S_L_5_dB)



print(S_L_1_dB)
print(S_L_2_dB)
print(S_L_3_dB)
print(S_L_4_dB)
print(S_L_5_dB)
print(S_C_2_dB)
print(S_C_4_dB)
# --- Usage Example ---
num_list = get_control_coeffs(sp.numer(Filter_TF), sol_dict, s)
den_list = get_control_coeffs(sp.denom(Filter_TF), sol_dict, s)
sys = ct.TransferFunction(num_list, den_list)

num_list_final = get_control_coeffs(sp.numer(Filter_TF), sol_dict_final, s)
den_list_final = get_control_coeffs(sp.denom(Filter_TF), sol_dict_final, s)
sys_final = ct.TransferFunction(num_list_final, den_list_final)

ct.bode(sys_final,dB=True,Hz=True)
mpl.cursor(multiple=True)

ct.bode(filter_tf,dB=True,Hz=True)
mpl.cursor(multiple=True)

ct.pzmap(sys)
ct.pzmap(filter_tf)

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

