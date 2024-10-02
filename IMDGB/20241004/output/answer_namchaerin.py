#%%
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import yfinance as yf
# pip install yfinance --upgrade --no-cache-dir <- 이거 bash terminal 에서 실행
from pandas import DataFrame
# import plotly

# 문제 1. 
"""
개발환경 설정 및, 깃허브 push 전과정 서술
"""
답1 = "ㅇㅇㅇㅇㅇㅇㅇㅇ"
#print(답1)

# 문제 2. 

# 내보내기 문제 : 이미지 2개, dataframe 내보내기 n개
# 내보내기 경로는 output으로 잡으면 됨.
# 
text = [1, 2, 3]
#print(text) 

# 중요하다고 한 기초 문법 나온다. 시각화는 하나는 그대로, 하나는 응용해서 나옴.


# estate=pd.read_csv("c:/Archiving/IMDGB/step02_ds_basic/dataset/seoul_real_estate.csv")

apple = yf.download("AAPL", start = "2020-01-01", end="2024-09-30")
nvidia = yf.download("NVDA", start = "2020-01-01", end="2024-09-30")
intel = yf.download("INTC", start="2020-01-01", end = "2024-09-30")
amazon = yf.download("AMZN", start="2020-01-01", end = "2024-09-30")

# 그래프 1
fig, ax = plt.subplots()
ax.plot(apple['Open'], label = 'apple')
ax.plot(nvidia['Open'], label = 'nvidia')
ax.set_title('Stocks')
ax.legend()
# %% 
plt.show()
plt.savefig('/output/myStocks111.png', format='png')


