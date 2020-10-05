def foo():
	return "Hello from foo"
	
def getCloudData(api_input, csv_output):
	import requests, json, csv
	import os
	# Force return from the server in JSON format
	headers = {'accept': 'application/json'}
	url1 = api_input
	#'https://sheets.googleapis.com/v4/spreadsheets/1qOAnVvPkfwWJRbvDcoYAUKgH-0eF3EpjYDFFtT5wCFY/values/CMS_SDOH_State!A1:F15000?key=AIzaSyD4vVV4HF7_Kotcg9vGcEjRvARIJITTnow'
	fileout2=csv_output
	#"cms_sdoh_state1.csv"
	# GET the object
	response1 = requests.get(url1, headers=headers)
	# Extract the JSON response as a Python dictionary
	datasample1 = response1.json()
	fileout1="temp1.json"
	print("This file full path (following symlinks)")
	full_path = os.path.realpath(fileout1)
	print(full_path + "\n")
	# Print the Python object
	print(json.dumps(datasample1, indent=4))
	with open(full_path, "w") as JSONFile:
		json.dump(datasample1, JSONFile)
	#import json
	import string
	import pandas as pd
	df = pd.read_json (fileout1)
	#df.drop(df.head(1).index, inplace=True)
	#(df['values']).to_string(index=False)
	#export_csv = df.to_csv (r'C:\Python\Projects\Test1\raw3.csv')
	header=["values"]
	export_csv = df.to_csv (fileout2, sep=',', columns=header, 
							header=False, index=False, index_label=False, doublequote=False)
	pd.read_csv(fileout2, nrows=5, delimiter = ',')						
	text1 = open(fileout2, "r")
	text1 = ''.join([i for i in text1]) \
		.replace('"[', '')
	text1 = ''.join([i for i in text1]) \
		.replace(']"', '')
	text1 = ''.join([i for i in text1]) \
		.replace("'", '').strip()
	text1 = ''.join([i for i in text1]) \
		.replace(", ", ",").strip()
	x = open(fileout2,"w")
	x.writelines(text1)
	x.close()						
	pd.read_csv(fileout2, nrows=5, delimiter = ',')
	#test3
	df1 = pd.read_csv(fileout2)
	df1.dtypes
	#test4
	df1.head()
	return "API Call completed!"

def transformL2W(file_long, file_wide, index1, index2, columns1, values1):
	import string
	import pandas as pd	
	df2 = pd.read_csv(file_long)
	df2.dtypes
	df2_transposed=pd.pivot_table(df2, index=[index1,index2], columns=columns1, values=values1,observed=False, margins=False).reset_index()
	df2_transposed
	df2_transposed.to_csv(file_wide, index=True)
	return "Data transformation completed!"