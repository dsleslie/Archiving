# -*- coding: utf-8 -*-

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns 
import plotly
import yfinance as yf
import plotly.graph_objects as go
from pandas import DataFrame

# 서술형 문제 1
"""
답안 작성
1) 깃허브에서 새로운 repo 'alpaco'를 생성합니다.
이때 python으로 지정한 gitignore 파일과 README 파일을 함께 생성합니다.

2) Git Bash 에서 git clone
생성한 새로운 레포를 저장할 로컬 위치에서 오른쪽 마우스 키를 눌러, 추가 옵션 표시에서 'open git bash here'을 선택합니다.
창에 git clone 뒤에 alpaco의 https링크를 복사해 shift+enter로 붙여넣습니다.
그 후 code . 를 눌러 vs code를 실행합니다.

3) vs code에서 가상환경 생성
Terminal - New Terminal 을 누른후 + 버튼에서 Git Bash를 찾아 새로운 bash 터미널을 생성합니다.
$ source venv/Scripts/activate 를 입력해 virtualenv 개발 환경에 접속합니다.
which python을 활용해 가상환경에 접속되었는 지 확인합니다.

4) main.py 생성
왼쪽 Explorer 창에서 'alpaco' 옆 단추 활용해 새로운 py 파일을 생성합니다.
이때 제목을 main.py 로 작성합니다.
생성된 main.py 화면에 코드를 작성합니다.

5) main.py를 git hub의 'alpaco' 레포지토리에 업로드
bash 터미널에서 
git add .
git commit -m "commit message"
git push
를 차례로 입력해 깃허브에 연동시킵니다. 


"""

# 코드 문제 1
result = []
for i in range(10):
    if i % 2 == 0:
        result.append(i * 2)
print(result)

# 답지
code_result1 = [i*2 for i in range(10) if i%2==0]
print(code_result1)

# 코드 문제 2
my_dict = {'apple': 3, 'banana': 5, 'orange': 2}

# 답지
# 여기서부터 코드 작성
my_dict = {
    'apple': 3, 
    'banana': 5, 
    'orange': 2
    }

print(my_dict)

# 코드 문제 3
series = pd.Series([25, 35, 45, 60, 75])
# 답지
# np.where를 사용하여 조건 적용
code_result3 = np.where(series>=30 & series<=60, a+10 , )

# 결과 출력
print(code_result3)

# 코드 문제 4
iris = sns.load_dataset("iris")

# 답지
# 여기서부터 코드 작성
df=pd.read_csv("iris")
# print(df)
iris=pd.to_csv("/output/code4_jungjihoon.csv")
iris=pd.to_excel("/output/code4_jungjihoon.xlsx")

# 코드 문제 5
data = [
    ["1,000", "1,100", '1,510'],
    ["1,410", "1,420", '1,790'],
    ["850", "900", '1,185'],
]
columns = ["03/02", "03/03", "03/04"]
df = pd.DataFrame(data=data, columns=columns)
df.info()

# 답지
# 여기서부터 코드 작성
# 사용자 정의 함수
def rm_comma(x):
    return int(x.replace(",",""))

# 사용자 정의 함수 잘 돌아가는 지 확인
y = "1,000"
print(rm_comma(y))
df["03/02"] = df["03/02"].apply(rm_comma)
df["03/03"] = df["03/03"].apply(rm_comma)
df.info()


# 코드 문제 6
apple = yf.download("AAPL", start="2020-01-01", end = "2024-09-30")
fig, ax = plt.subplots()
ax.plot(apple['Open'], label = "Apple")
ax.legend()
plt.show()


# 답지
# 여기서부터 코드 작성
plt.savefig('/output/code6_jungjihoon.png')

# 코드 문제 7
tips = sns.load_dataset("tips")

# 답지
# 여기서부터 코드 작성
import matplotlib.pyplot as plt
import seaborn as sns

fig, ax = plt.subplots(nrows=3, ncols=3, figsize=(10,4))
ax.scatter(x, y)
ax[1,1].plot(tips['total_bill'], label = 'tips', color ='blue')
ax[1, 1].set_title('Scatter Plot of Total Bill vs Tip')
ax.set_xlabel('Total Bill')
ax.set_ylabel('Tip')
ax[1, 1].legend()
fig.tight_layout() 
plt.savefig('/output/code7_jungjihoon.png')





# 코드 문제 8
apple = yf.download("AAPL", start="2024-05-01", end="2024-09-30")

# 답지
# 여기서부터 코드 작성
import yfinance as yf
import plotly.graph_object as go
fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(10,4))
fig = go.Figure(data=[go.Candlestick(x=df['Date'],
                open=df['AAPL.Open'],
                high=df['AAPL.High'],
                low=df['AAPL.Low'],
                close=df['AAPL.Close'])])

fig.update_layout(
    title='AAPL Candlestick Chart (2020-2024)',  # 차트 제목
    yaxis_title='Price(USD)',  # y축 레이블
fig.update_traces(
    increasing_line_color='lightgray',  # 상승 봉의 색상
    decreasing_line_color='yellow'  # 하락 봉의 색상
)


)
fig.show()
