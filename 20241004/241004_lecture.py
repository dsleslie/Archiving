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
#data = [
 #   ["전기전자", "005930", "삼성전자", 74400],
 #   ["화학", "051910", "LG화학", 896000],
 #   ["카카오", "000660", "SK하이닉스", 101500]
#]

#columns = ["업종", "종목코드", "종목명", "현재가"]
#df1 = DataFrame(data=data, columns=columns)

# 두 번째 데이터프레임
#data = [
#    ["은행", 2.92],
#    ["보험", 0.37],
#    ["화학", 0.06],
#    ["전기전자", -2.43]
#]

#columns = ["업종", "등락률"]
#df2 = DataFrame(data=data, columns=columns)

#df= pd.merge(left = df1, right = df2, how = 'left', on='업종')
#print(df)
# left join: 왼쪽 데이터 프레임은 그냥 가져오고, 
# 오른쪽 데이터 프레임은 맞는 행 있으면 컬럼 그대로 갖다 붙이는데, 
# 안맞는 값은 NaN 처리
# how = 기본값은 'inner' 즉 inner join <- 양쪽 키값이 맻이 되는 거만 가져옴. 즉 left에서 Nan이었던 행은 안나온 것

#inner
#df_inner= pd.merge(left = df1, right = df2,  on='업종')
#print(df_inner)

#right
#df_right= pd.merge(left = df1, right = df2, how='right', on='업종')
#print(df_right)

#outer
#df_outer= pd.merge(left = df1, right = df2, how = 'outer',  on='업종')
#print(df_outer)

# join 걸 때 기억해야 할 것 = merge 사용 시기억할 것
# inner, left 위주로 쓰면 됨.
# 이유 : 기준테이블을 left 등으로 잡는 다는 뜻이니, 기준 테이블을 굳이 right로 잡을 필요는 없기 때문에...

### if) 두번째 데이터프레임의 columns에 업종이 아니라 항목으로 바꿈
# 이 경우엔 left로 하든 뭘로 하든 merge하는 기준인 '업종' 이 없기에 key error 뜸
# 컬럼 이ㅡㄻ 바꾸는 게 좋긴하지만, 이름 바꾸기 가 안되는 경우,
# left on, right on 옵션을 준다. 아래 처럼
# df= pd.merge(left = df1, right = df2, how = 'left', left_on='업종', right_on='항목')
# 이러면 같은 키 값으로 인지한다.




## join
#data = [
 #   ["전기전자", "005930", "삼성전자", 74400],
 #   ["화학", "051910", "LG화학", 896000],
 #   ["카카오", "000660", "SK하이닉스", 101500]
#]

#columns = ["업종", "종목코드", "종목명", "현재가"]
#df1 = DataFrame(data=data, columns=columns)
#df1 = df1.set_index('업종')

# 두 번째 데이터프레임
#data = [
 #   ["은행", 2.92],
 #   ["보험", 0.37],
 #   ["화학", 0.06],
 #   ["전기전자", -2.43]
#]

#columns = ["항목", "등락률"]
#df2 = DataFrame(data=data, columns=columns)
#df2 = df2.set_index('항목')

# join 해보자
#print(df1.join(other=df2, how = 'left'))

# 차이 설명.
# merge = 기본값: inner join
# join 기본값 : left join
# join 하든, merge 쓰든 같은 구문이니, how = '방식' 쓰는게 좋다!

# 문제!
# 연도별로 그룹바이 연산, 시가총액 평균 구하기
data = [
    ["2017", "삼성", 500],
    ["2017", "LG", 300],    
    ["2017", "SK하이닉스", 200],
    ["2018", "삼성", 600],
    ["2018", "LG", 400],
    ["2018", "SK하이닉스", 300],    
]

columns = ["연도", "회사", "시가총액"]
df = DataFrame(data=data, columns=columns)
df

#result = df.groupby("연도")[["시가총액"]].mean()
#print(result)
#print(type(result))
# 이걸 데이터프레임으로 만들어야 합칠 수 있음. 그래서 데이터 프레임으로 만들어야 함.

result = df.groupby("연도")[["시가총액"]].mean() #.to_frame() ?? 뭐지 d왜 나는 이미 df였지?
result.columns = ['시가총액평균']
print(result)
print(type(result))

df2 = df.join(result, on = '연도') # 연도로 지정해줘야, df와 result가 다른 형태임에도, 알아서 잘 찾아서 값 넣어줌.
print(df2)
