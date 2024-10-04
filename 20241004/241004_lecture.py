import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import yfinance as yf
# pip install yfinance --upgrade --no-cache-dir <- 이거 bash terminal 에서 실행
from pandas import DataFrame
# import plotly

# 폴더 생성
# os 라이브러리
import os
if not os.path.isdir("abcd"):
    os.mkdir("abcd") # 폴더 생성

data = {
    "종목명": ["3R", "3SOFT", "ACTS"],
    "현재가": [1510, 1790, 1185],
    "등락률": [7.36, 1.65, 1.28],
 }

df = DataFrame(data, index=["037730", "036360", "005760"])


# df.to_csv("abcd/data.csv")
# df.to_excel("abcd/data.xlsx")

df.to_csv("output/data2.csv")
df.to_excel("output/data2.xlsx")


## 수업시작
# concat 이라는 함수

# 첫번째 데이터프레임
# data = {
#    '종가': [113000, 111500],
#    '거래량': [555850, 282163]
#}
#index = ["2019-06-21", "2019-06-20"]
#df1 = DataFrame(data, index=index)
#print(df1)

# 두번째 데이터프레임
#data2 = {
#    '종가': [110000, 483689],
#    '거래량': [109000, 791946]
#}
#index2 = ["2019-06-19", "2019-06-18"]
#df2 = DataFrame(data2, index=index2)
#print(df2)

# concat 써보자. dataframe 합치는 것.
# concat: 두 개 컬럼을 그냥 이어주는 것, 그래서 concat안에 df 순서 바꾸면 result도 달라진다. 그냥 합지기만 하기 때문.
# 컬럼수가 다른 두 데이터프레임을 합친다면? 매칭이 되는건 그냥 합쳐지고, 매칭 안되는 곳은 NaN으로 값 나옴. ㅇㅋ 
# 인덱스 타입이 달라도 이어 붙여짐. 
# 즉 그냥 합쳐지기만 하는 거임. 그래서 사전에 두 dataframe 인덱스 타입을 동일하게 합치는 게 좋음.
#result = pd.concat([df1,df2])
#print(result)

##
# merge
# 첫 번째 데이터프레임
#data = [
 #   ["전기전자", "005930", "삼성전자", 74400],
  #  ["화학", "051910", "LG화학", 896000],
   # ["전기전자", "000660", "SK하이닉스", 101500]
#]

#columns = ["업종", "종목코드", "종목명", "현재가"]
#df1 = DataFrame(data=data, columns=columns)

# 두 번째 데이터프레임
#data = [
 #   ["은행", 2.92],
  #  ["보험", 0.37],
# ["화학", 0.06],
 #   ["전기전자", -2.43]
#]

#columns = ["업종", "등락률"]
#df2 = DataFrame(data=data, columns=columns)

# merge 해보자
#print(pd.merge(left = df1, right = df2, on = '업종'))
#print(df1)
#print(df2)
# merge 결과 해석
# 두 데이터프레임에서 겹치지 않는 업종은 사라지고, 겹치는 거만 남으면서 컬럼은 붙여짐
# sql에서는 join 건다고 함.

### 
data = [
    ["전기전자", "005930", "삼성전자", 74400],
    ["화학", "051910", "LG화학", 896000],
    ["카카오", "000660", "SK하이닉스", 101500]
]

columns = ["업종", "종목코드", "종목명", "현재가"]
df1 = DataFrame(data=data, columns=columns)

# 두 번째 데이터프레임
data = [
    ["은행", 2.92],
    ["보험", 0.37],
    ["화학", 0.06],
    ["전기전자", -2.43]
]

columns = ["업종", "등락률"]
df2 = DataFrame(data=data, columns=columns)

df= pd.merge(left = df1, right = df2, how = 'left', on='업종')
print(df)
# left join: 왼쪽 데이터 프레임은 그냥 가져오고, 
# 오른쪽 데이터 프레임은 맞는 행 있으면 컬럼 그대로 갖다 붙이는데, 
# 안맞는 값은 NaN 처리
# how = 기본값은 'inner' 즉 inner join <- 양쪽 키값이 맻이 되는 거만 가져옴. 즉 left에서 Nan이었던 행은 안나온 것

#inner
df_inner= pd.merge(left = df1, right = df2,  on='업종')
print(df_inner)

#right
df_right= pd.merge(left = df1, right = df2, how='right', on='업종')
print(df_right)

#outer
df_outer= pd.merge(left = df1, right = df2, how = 'outer',  on='업종')
print(df_outer)

# join 걸 때 기억해야 할 것 = merge 사용 시기억할 것
# inner, left 위주로 쓰면 됨.
# 이유 : 기준테이블을 left 등으로 잡는 다는 뜻이니, 기준 테이블을 굳이 right로 잡을 필요는 없기 때문에...