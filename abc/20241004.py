#현재 프로젝트  폴더(최상위 폴더) 기준, abc 폴더를 생성하고 abc 폴더 내 아래 데이터프레임을 내보내기 하세요.
#CSV / Excel 파일 모두
#실행 파일명 : 20241004.py
#today_stock.csv, today_stock.xlsx

# 문제 설명
# 현재 프로젝트 폴더(최상위 폴더) : 레포 폴더 (venv가 보이는 폴더)

import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import yfinance as yf
# pip install yfinance --upgrade --no-cache-dir <- 이거 bash terminal 에서 실행
from pandas import DataFrame
import plotly

#data = {
#    "종목명": ["3R", "3SOFT", "ACTS"],
#    "현재가": [1510, 1790, 1185],
#    "등락률": [7.36, 1.65, 1.28],
# }

#df = DataFrame(data, index=["037730", "036360", "005760"])
#df

#df.to_csv("today_stock.csv")
#df.to_excel("today_stock.xlsx")
#df.to_excel("output_test/today_stock.xlsx")
#df.to_csv("today_stock.csv" , index = True) index = True 면 인덱스 포함 출력, fAlse 면 빼고 출력


#dates = [
#    '2021-01-01', '2021-01-02', '2021-01-03', '2021-01-04', '2021-01-05',
#    '2021-01-06', '2021-01-07', '2021-01-08', '2021-01-09', '2021-01-10'
#] 
# 지금 자료형이 list임. matpolitlib은 기본적으로 list를 받음. dataframe으로 작업하던 걸 list로 변환해야함. 
#min_temperature = [20.7, 17.9, 18.8, 14.6, 15.8, 15.8, 15.8, 17.4, 21.8, 20.0]
#max_temperature = [34.7, 28.9, 31.8, 25.6, 28.8, 21.8, 22.8, 28.4, 30.8, 32.0]


#fig, ax = plt.subplots(nrows = 1, ncols = 1, figsize=(10, 6))
#ax.plot(dates, min_temperature, label = "Min Temp")
#ax.plot(dates, max_temperature, label = "Max Temp")
#ax.legend()
#plt.show()
# plt.savefig('png_test1.png') 오 된다.
# plt.savefig('output_test/png_test2.png') 오 된다.

#apple = yf.download("AAPL", start = "2020-01-01", end="2024-09-30")
#nvidia = yf.download("NVDA", start = "2020-01-01", end="2024-09-30")
#intel = yf.download("INTC", start="2020-01-01", end = "2024-09-30")
#amazon = yf.download("AMZN", start="2020-01-01", end = "2024-09-30")

#fig, ax = plt.subplots(nrows=2, ncols=2, figsize=(10,4))
# nrows, ncols로 그래프 몇개 생성할 지


#ax[0, 0].plot(apple['Open'], label = 'apple', color ='red')
#ax[0, 1].plot(nvidia['Open'], label = 'nvidia' , color='green')
#ax[1,0].plot(intel['Open'], label = 'intel', color ='blue')
#ax[1, 1].plot(amazon['Open'], label = 'amazon' , color='orange')

#ax[0, 0].set_title('Apple Stocks')
#ax[0, 1].set_title('Nvidia Stocks')
#ax[1, 0].set_title('Intel Stocks')
#ax[1, 1].set_title('Amazon Stocks')

#ax[0, 0].legend()
#ax[0, 1].legend()
#ax[1, 0].legend()
#ax[1, 1].legend()

#fig.tight_layout()

#ax[0, 0].grid()
#ax[0, 1].grid()
#ax[1, 0].grid()
#ax[1, 1].grid()
#plt.savefig('myStocks.png')
#plt.savefig('output_test/myStocks2.png')
#plt.show()

import plotly.graph_objects as go
import plotly.express as px

fig = go.Figure(data=[go.Bar(x = ["a", "b", "c"], y = [1, 3, 2])])
fig.update_layout(title_text = '타이틀 설정')
fig.show()
#fig.write_image("/output_test/plot.png")
#plt.savefig("/output_test/plot.png")
