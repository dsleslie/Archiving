import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import yfinance as yf
# pip install yfinance --upgrade --no-cache-dir <- 이거 bash terminal 에서 실행
from pandas import DataFrame
import plotly

import plotly.graph_objects as go
import plotly.express as px 

# 문제 1. 
"""
개발환경 설정 및, 깃허브 push 전과정 서술
"""
답1 = "ㅇㅇㅇㅇㅇㅇㅇㅇ"
print(답1)

# 문제 2. 

# 내보내기 문제 : 이미지 2개, dataframe 내보내기 n개
# 내보내기 경로는 output으로 잡으면 됨.
# 
text = [1, 2, 3]
print(text) 


#fig = go.Figure()

# 기본적인 자료형은 list를 참조함
#fig.add_trace(go.Bar(x=[1,2,3],y=[1,5,3]))

#fig.show()

# 캔들 스틱 documentation에서 샘플코드 가져옴
df = pd.read_csv('https://raw.githubusercontent.com/plotly/datasets/master/finance-charts-apple.csv')
# 데이터를 url로 가져옴
# 깃허브에다가 레포 하나 만들고, 누군가가 만들어서 그 링크르 다른 사람들한테 공유하면, 그걸 이어서 받아서 작업할 수 있음..... 팀플하기전에 고려기기

fig = go.Figure(data=[go.Candlestick(x=df['Date'],
                open=df['AAPL.Open'],
                high=df['AAPL.High'],
                low=df['AAPL.Low'],
                close=df['AAPL.Close'])])

fig.show()
#plt.savefig('test1.png')
fig.write_image('output/image_file.png',height=600, width=850)

