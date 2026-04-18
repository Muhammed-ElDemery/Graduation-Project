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

instr.setCircuit("GM_C_filter2.spice")
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
#sp.simplify(res.laplace)

FILTER_TF_SYMBOLIC = res.laplace
k_1 , k_2 ,k_3, k_4 ,k_5 , k_s , k_l = sp.symbols('k_1 k_2 k_3 k_4 k_5 k_s k_l')
# BEHAVEIOR MODEL
[nume, denum] = ellip(5,0.2,30,1,analog=True)
[nume2, denum2] = ellip(5,0.2,30,2*np.pi*260e6,analog=True)


filter_tf = ct.tf(nume,denum)
filter_tf2 = ct.tf(nume2,denum2)

ct.bode(filter_tf2,dB=True,Hz=True)
mpl.cursor(multiple=True)
  

Poles_array = ct.poles(filter_tf)
Zeros_array = ct.zeros(filter_tf)
filter_Gain = 1;
filter_symbolic = ct_to_sympy(filter_tf,s)
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
AV_1 = sp.symbols('AV_1')
#RL , RS,RLOSS = sp.symbols('RL RS RLOSS')
#RL , RS,QF = sp.symbols('RL RS QF')
#denom = sp.denom(res.laplace)
#nume = sp.numer(res.laplace)


#Filter_TF = res.laplace.subs(RL,RL_value)
#Filter_TF = Filter_TF.subs(RS,RS_value)
AV_value = 250
#jRO_value = QF_value/gm_value
#Filter_TF = Filter_TF.subs(RLOSS,RLOSS_value)
#Filter_TF = Filter_TF.subs(QF,QF_value)
# Equal Ks
#k_array = np.linspace(0.5,1.5,10)
#Max_comp_array = np.zeros(10)
#Min_comp_array = np.zeros(10)
#Component_spread_array = np.zeros(10)
#for iter in range(1,10):
    #k_s_value = k_array[iter]
    #k_l_value = k_array[iter]
    FILTER_TF_WITH_GM = FILTER_TF_SYMBOLIC.subs([(k_1 , 1) , (k_2,1) , (k_3,1) , (k_4,1) , (k_5 , 1) ,(k_s ,1) , (k_l,1)])
    FILTER_TF=FILTER_TF_WITH_GM.subs([(gm_1 , gm_value) , (AV_1 , AV_value)])
    #Filter_TF = res.laplace.subs([(gm_1,gm_value),(RO1,RO_value)])
    FILTER_SYMBOLIC_COEFF_CIRCUIT =coeffsTransfer(FILTER_TF)

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

    L_1 , L_2 , C_1 , C_2, C_3 ,C_4 ,C_5 = sp.symbols('L_1  L_2  C_1  C_2 C_3 C_4 C_5 ')

    #solution = sp.nsolve(SYM_M - BEHAVE_M ,[C_1 , L_2 , C_3 , L_4, C_5 ,C_Z1 , C_Z2],[1 ,1,1,1,1,1,1])
    EQUATIONS = SYM_M - BEHAVE_M 
    #print(EQUATIONS)
    filtered_rows = [EQUATIONS.row(i) for i in range(EQUATIONS.rows) if not EQUATIONS.row(i).is_zero_matrix]
    filtered_rows
    F_clean = sp.Matrix.vstack(*filtered_rows)
    F_clean
    # 1. Convert SymPy matrix to a numerical function
    # We use 'numpy' for speed and stability
    func = sp.lambdify(([L_1 , L_2 , C_1 , C_2, C_3 ,C_4 ,C_5],), F_clean, modules='numpy')
    active_vars = [L_1 , L_2 , C_1 , C_2, C_3 ,C_4 ,C_5]
    # 2. Wrapper to flatten the output for scipy
    def f(x):
        return np.array(func(x)).astype(float).flatten()

    #X_inital = [0.181 , 0.058 , 0.16 , 0.24 , 0.09 , 0.195 , 0.115]
    #solution = fsolve(f, x0=[1]*len(active_vars))

    results = least_squares(
        f, 
        x0=[2]*7, 
        method='trf',     # 'trf' (Trust Region Reflective) is more precise than 'lm'
        bounds = (0.001,100),
        ftol=1e-15,       # Default is 1e-8
        xtol=1e-15,       # Default is 1e-8
        gtol=1e-15,       # Default is 1e-8
        max_nfev=5000     # Allow more iterations to reach this precision
    )
    results.success
    #solution = fsolve(f, x0=X_inital)
    #solution = results.x
    #print("Solution:", solution)
    #active_vars
    sol_dict = dict(zip(active_vars, results.x))
    sol_dict_final = dict()
    for key in sol_dict.keys():
        sol_dict_final[key]=sol_dict[key]/(260e6*2*np.pi)

    sol_dict
    F_clean.subs(sol_dict)

    sol_dict_final

    # Impelementation
    gm_actual_value = 2.1e-3
    sol_dict_final_realization = dict()
    for key in sol_dict.keys():
        sol_dict_final_realization[key]=sol_dict_final[key]*gm_actual_value

    sol_dict_final_realization
    Max_component = np.max(list(sol_dict_final_realization.values()))
    Min_component = np.min(list(sol_dict_final_realization.values()))
    component_spread = Max_component/Min_component
    print(component_spread)
#    Component_spread_array[iter] = component_spread
#    Max_comp_array[iter] = Max_component
#    Min_comp_array[iter] = Min_component

#plt.plot(k_array,Component_spread_array)
#mpl.cursor(multiple=True)

#plt.plot(k_array,Min_comp_array)
#mpl.cursor(multiple=True)
miller_pole =  2*np.pi*15e9
#gm_TF = gm_actual_value/(1+s/miller_pole)
gm_TF = gm_actual_value
#Transfer_Function = FILTER_TF_WITH_GM.subs([(gm_1,gm_actual_value),(AV_1,AV_value)])
Transfer_Function = FILTER_TF_WITH_GM.subs([(gm_1,gm_TF),(AV_1,AV_value)])
Transfer_Function= sp.ratsimp(Transfer_Function)
num_list_real = get_control_coeffs(sp.numer(Transfer_Function), sol_dict_final_realization, s)

den_list_real = get_control_coeffs(sp.denom(Transfer_Function), sol_dict_final_realization, s)
Filter_TF_realization_control = ct.tf(num_list_real , den_list_real)

# Testing 
Filter_TF_realization_control.num
Filter_TF_realization_control.den
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
num_list = get_control_coeffs(sp.numer(FILTER_TF), sol_dict, s)
den_list = get_control_coeffs(sp.denom(FILTER_TF), sol_dict, s)
sys = ct.TransferFunction(num_list, den_list)

num_list_final = get_control_coeffs(sp.numer(FILTER_TF), sol_dict_final, s)
den_list_final = get_control_coeffs(sp.denom(FILTER_TF), sol_dict_final, s)
sys_final = ct.TransferFunction(num_list_final, den_list_final)

ct.bode(sys_final,dB=True,Hz=True)
mpl.cursor(multiple=True)

ct.bode(filter_tf,dB=True,Hz=True)
mpl.cursor(multiple=True)

ct.pzmap(sys,title='Lossless filter')
ct.pzmap(filter_tf,label='Lossy filter')


cons = [
    {'type': 'ineq', 'fun': filter_constraints},
    {'type': 'ineq', 'fun': bound_constraints1},
    {'type': 'ineq', 'fun': bound_constraints2}
]

results_opt = minimize(
    objective_func, 
    x0=results.x, 
    method='COBYLA', 
    constraints=cons,
    options={
        'rhobeg': 0.1,    # Try changing parameters by ~10% initially
        'maxiter': 5000,  # Give it plenty of time to wander
        'disp': True      # Print progress to the console
    }
)
results_opt.success
results_opt.x
results.x
def objective_func(x):
    RESPON = calc_response(x)
    DC_GAIN = RESPON[0]
    MAG_AT_250M = RESPON[1]
    MAG_AT_300M = RESPON[2]
    return  MAG_AT_300M

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
    coeffs = [float(c) if abs(c) > 1e-200 else 0.0 for c in poly.all_coeffs()]
    
    return coeffs

def calc_response(x):
    global GLOBAL_FILTER_TF_WITH_GM
    global s 
    global gm_1
    global AV_1
    global active_vars
    sol_dict_X = dict(zip(active_vars, x))
    sol_dict_final_X = dict()
    for key in sol_dict_X.keys():
        sol_dict_final_X[key]=sol_dict_X[key]/(250e6*2*np.pi)
    gm_actual_value = 2.1e-3
    sol_dict_final_realization = dict()
    for key in sol_dict.keys():
        sol_dict_final_realization[key]=sol_dict_final[key]*gm_actual_value

    miller_pole =  50e9
    AV_value = 250

    #gm_TF = gm_actual_value/(1+s/miller_pole)
    gm_TF = gm_actual_value
    GLOBAL_FILTER_TF_WITH_GM_mod = GLOBAL_FILTER_TF_WITH_GM.subs(sol_dict_final_realization)

    Transfer_Function = GLOBAL_FILTER_TF_WITH_GM_mod.subs([(gm_1,gm_TF),(AV_1,AV_value)])

    
    Transfer_Function= sp.ratsimp(Transfer_Function)
    num_list_real = get_control_coeffs2(sp.numer(Transfer_Function), s)
    den_list_real = get_control_coeffs2(sp.denom(Transfer_Function), s)
    Filter_TF_realization_control = ct.tf(num_list_real , den_list_real)

    RESP_AT_250M = ct.freqresp(Filter_TF_realization_control,250e6*2*np.pi)
    RESP_AT_1 = ct.freqresp(Filter_TF_realization_control,1)
    RESP_AT_300M = ct.freqresp(Filter_TF_realization_control,2*np.pi*300e6)

    MAG_AT_250M = 20*np.log10(RESP_AT_250M[0])
    MAG_AT_300M = 20*np.log10(RESP_AT_300M[0])
    DC_GAIN = 20*np.log10(RESP_AT_1[0])
    return [float(DC_GAIN[0]) , float(MAG_AT_250M[0]) , float(MAG_AT_300M[0])]


def filter_constraints(x):
    RESPON = calc_response(x);
    #RESPON = calc_response(results.x);
    DC_GAIN = RESPON[0];
    MAG_AT_250M = RESPON[1];
    MAG_AT_300M = RESPON[2];
    c1= MAG_AT_250M-DC_GAIN +0.5
    c2 =-MAG_AT_250M
    #c3 =DC_GAIN - MAG_AT_300M -25
    return np.array([c1, c2])

def bound_constraints1(x):
    # Ensures every parameter in x is at least a tiny positive number
    # If x[0] drops below 1e-9, this becomes negative and COBYLA rejects it
    c1 = x - 1e-3
    return c1

def bound_constraints2(x):
    # Ensures every parameter in x is at least a tiny positive number
    # If x[0] drops below 1e-9, this becomes negative and COBYLA rejects it
    c1 = 1e2 - x
    return c1

GLOBAL_FILTER_TF_WITH_GM = FILTER_TF_WITH_GM
def get_control_coeffs2(expr, s_var):
    """
    Converts a symbolic expression to a list of floats.
    
    Args:
        expr: The SymPy expression (numerator or denominator).
        sol_dict: Dictionary of {Symbol: float} from your solver.
        s_var: The SymPy symbol for Laplace 's'.
    """
    expanded_expr = sp.expand(expr)
    
    # 3. Use SymPy Poly to extract all coefficients including zeros
    # 'domain=sp.RR' forces numerical coefficients
    poly = sp.Poly(expanded_expr, s_var, domain=sp.RR)
    
    # 4. Convert SymPy Floats to standard Python floats
    # all_coeffs() returns them in descending order: [s^n, ..., s^1, s^0]
    coeffs = [float(c) if abs(c) > 1e-200 else 0.0 for c in poly.all_coeffs()]
    
    return coeffs
