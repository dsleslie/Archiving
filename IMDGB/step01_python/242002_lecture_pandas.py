import pandas as pd
from pandas import DataFrame

data = [
    ["037730", "3R", 1510],
    ["036360", "3SOFT", 1790],
    ["005670", "ACTS", 1185]
]

columns = ["종목코드", "종목명", "현재가"]
df = DataFrame(data=data, columns=columns)
df.set_index("종목코드", inplace=True)
# print(df)


# 정렬 하기
# df.sort_values(by='현재가')
# print(df.sort_values(by='현재가'))
# ascending=False : 내림차순 , = True 가 기본 값= 오름차순
# print(df.sort_values(by='현재가',ascending=False))
# print(df.sort_values(by='종목명',ascending=False))

# print(df.sort_index()) # 기본값
# print(df.sort_index(ascending=False)) # 역순

# 인덱스 연산: 집합 연산 개념이 들어가 있음. 이를 통해 데이터 병합할 때 사용
idx1=pd.Index([1, 2, 3])
idx2=pd.Index([2,3,4])

#print(idx1.union(idx2))
# union  : 합집합 되는 것. 즉 위에 unino 하면 중복되는 2,3 은 겹치니까, 합집합 하면 1,2,3,4  인 것
#print(idx1.intersection(idx2))
# intersection: 교집합

#print(idx1.difference(idx2))
# 차집합


# groupby 연산
from pandas import DataFrame

data = [
    ["2차전지(생산)", "SK이노베이션", 10.19, 1.29],
    ["해운", "팬오션", 21.23, 0.95],
    ["시스템반도체", "티엘아이", 35.97, 1.12],
    ["해운", "HMM", 21.52, 3.20],
    ["시스템반도체", "아이에이", 37.32, 3.55],
    ["2차전지(생산)", "LG화학", 83.06, 3.75]
]

columns = ["테마", "종목명", "PER", "PBR"]
df = DataFrame(data=data, columns=columns)
print(df)