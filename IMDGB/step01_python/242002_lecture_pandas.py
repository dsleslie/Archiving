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
#print(df)


#result = df.groupby("테마")[["PER","PBR"]]
#print(type(result))

#result = df.groupby("테마")[["PER","PBR"]].mean()
#print(result)
#print(type(result))
# 요기까지가 분석해야할 테이블. 그걸 한번 본것. 나중에는 굉장히 데이터가 커짐

# get_group : 테마로 그룹화한 것 안에서 쪼개
# print(df.groupby("테마").get_group("2차전지(생산)"))
# print(df.groupby("테마").get_group("시스템반도체"))
# print(df.groupby("테마").get_group("해운"))

# 얘를 내보내야함. 그게 문제.
# result = df.groupby("테마")[["PER","PBR"]].mean()
# result.to_csv("c:/Archiving/IMDGB/20241004/output/result_csv_240930.xlsx")
# 오 된다. 왜 그래프는 안되지


# 오후 

df = pd.read_excel("c:/Archiving/IMDGB/step02_ds_basic/dataset/ss_ex_1.xlsx" , parse_dates=['일자'], index_col=0)
# print(df.head())
# 이런 파일 가져오면, 연도/월/일로 쪼개서 관리할 수 있다.
df = df.reset_index()
#print(df.head(1))
#print(df.info())
# print(df['일자'].dt.quarter) # 분기 정보가 나온다
# print(df['일자'].dt.year) # 연 정보가 나온다
# print(df['일자'].dt.month) # 월 정보가 나온다
# print(df['일자'].dt.day) # 일 정보가 나온다
# 참고: https://pandas.pydata.org/docs/reference/api/pandas.DatetimeIndex.html
# 연습할 것: https://pandas.pydata.org/docs/user_guide/timeseries.html

# column 추가
df['분기'] = df['일자'].dt.quarter
df['연도'] = df['일자'].dt.year 
df['월'] = df['일자'].dt.month
df['일'] = df['일자'].dt.day
#print(df.head(3))

# 묶기
# result = df.groupby(['연도', '월']).get_group((2021, 2))
# print(result.head())
#result = df.groupby(['연도','월'])['시가'].mean()
# print(result)

# 각 월별 종가, 저가, 고가 알고 싶은거
# 이떈 딕셔너리가 필요함
multiples = {
   "시가" : "first",
   "저가" : min,
   "고가" : max,
   "종가" : 'last' 
}
result = df.groupby(['연도','월']).agg(multiples)
print(result)
# group by 어렵..
print(result.reset_index()) # 리셋 인덱스 해야 처리하기 쉬움. ..아님 각 컬럼을 만드는게 나음. 



