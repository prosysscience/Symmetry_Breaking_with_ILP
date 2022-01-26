import pandas as pd
from scipy import stats
import seaborn as sns
import matplotlib.pyplot as plt
import os

for file in os.listdir("."):
	if file.endswith(".csv"):
		df = pd.read_csv(file)	
		name=file[:-4]	
		print("-----------------------------------------------")
		print("Analysis of", file)
		print("-----------------------------------------------")
		df = pd.read_csv(file)
		print(df[['SOLVING_TIME_DEFAULT','SOLVING_TIME_CUSTOM']].describe())
		df['difference'] = df['SOLVING_TIME_DEFAULT'] - df['SOLVING_TIME_CUSTOM']

		w,p = stats.shapiro(df['difference'])
		print('Shapiro-Wilk test for normality:') 
		print(f'	W test value:	{w:.5f}')
		print(f'	p value:	{p:.10f}')
		
		t,pt = stats.wilcoxon(df['difference'], mode='approx', alternative='greater')
		print('Wilcoxon T-test:')
		print(f'	T value:	{t:.3f}')
		print(f'	p value:	{pt:.10f}')
		print("-----------------------------------------------\n")
		new_df_data = []
		for index, row in df.iterrows():
			tmp1 = dict()
			tmp1['method'] = 'first'
			tmp1['result'] = row['SOLVING_TIME_DEFAULT']
			new_df_data.append(tmp1)
			tmp2 = dict()
			tmp2['method'] = 'second'
			tmp2['result'] = row['SOLVING_TIME_CUSTOM']
			new_df_data.append(tmp2)
		df = pd.DataFrame(new_df_data)
		df.head()
		sns.set()
		plt.rcParams['font.family'] = 'serif'
		plt.rcParams['font.serif'] = ['Times New Roman'] + plt.rcParams['font.serif']
		#plt.rcParams["font.family"] = "Times New Roman"
		plt.rcParams['font.size'] = '80'
		plot = sns.catplot(x='method', y='result', kind="box", data=df, order=['first', 'second'], showfliers = False)
		plot.set(xticklabels=["default", "custom"], xlabel=f'Scoring function', ylabel='Solving time in seconds')
		plot.savefig(f'{name}_plot.png')

