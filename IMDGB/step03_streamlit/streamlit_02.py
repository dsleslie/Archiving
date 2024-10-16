# -*- coding: utf-8 -*-
import streamlit as st 
import pandas as pd 

# 캐시메모리는 대용량 데이터는 불러오면 안됨
# 현업: SQL 데이터 가공을 일부 진행
# 쉽게 말하면 Raw 데이터는 끌고 오면 안됨

@st.cache_data
def load_data():
    train = pd.read_csv('c:/Archiving/IMDGB/step03_streamlit/data/train.csv')
    return train 

def main():
    st.title("여기에서부터 시작")

    train = load_data()
    print(train.head())
    st.dataframe(train) # 요거 넣으면 웹사이트 상 출력됨
    edited_df = st.data_editor(train)
    # st.table(train) : 가급적 쓰지 말자.


if __name__ == "__main__":
    main()

"""
df = pd.DataFrame(
    [
       {"command": "st.selectbox", "rating": 4, "is_widget": True},
       {"command": "st.balloons", "rating": 5, "is_widget": False},
       {"command": "st.time_input", "rating": 3, "is_widget": True},
   ]
)
edited_df = st.data_editor(df)

favorite_command = edited_df.loc[edited_df["rating"].idxmax()]["command"]
st.markdown(f"Your favorite command is **{favorite_command}** 🎈")
"""

data_df = pd.DataFrame(
    {
        "sales": [
            [0, 4, 26, 80, 100, 40],
            [80, 20, 80, 35, 40, 100],
            [10, 20, 80, 80, 70, 0],
            [10, 100, 20, 100, 30, 100],
        ],
    }
)

st.data_editor(
    data_df,
    column_config={
        "sales": st.column_config.BarChartColumn(
            "Sales (last 6 months)",
            help="The sales volume in the last 6 months",
            y_min=0,
            y_max=100,
        ),
    },
    hide_index=True,
)

st.dataframe(data_df)



"""
@st.cache_data
def load_data():
    df = sns.load_dataset('tips')
    return df

def main():
    st.title("Streamlit with Matplotlib")   
    tips = load_data()

    # 데이터가공
    m_tips = tips.loc[tips['sex'] == 'Male', :]
    f_tips = tips.loc[tips['sex'] == 'Female', :]

    # 시각화 차트
    fig, ax = plt.subplots(ncols=2, figsize=(10, 6), sharex=True, sharey=True)
    ax[0].scatter(x = m_tips['total_bill'], y = m_tips['tip'])
    ax[0].set_title('Male')
    ax[1].scatter(x = f_tips['total_bill'], y = f_tips['tip'])
    ax[1].set_title('Female')

    # 중요포인트
    # plt.show()
    st.pyplot(fig)

if __name__ == "__main__":
    main()


@st.cache_data
def load_data():
    train = pd.read_csv('c:/Archiving/IMDGB/step03_streamlit/data/train.csv')
    return train

def main():
    st.title("Explatory Data Analysis")   
    train = load_data()


class StackedBarplot:                                       # StackedBarplot 클래스
    def __init__(self, df, feature, target='loan_status' ): # init 메서드
        self.df = df
        self.feature = feature
        self.target = target

    def plot(self):                                         # plot 메서드
# crosstab 생성
        crosstab = pd.crosstab(self.df[self.feature], self.df[self.target], normalize='index')
        fig, ax = crosstab.plot(kind = 'bar', stacked = True, figsize = (12,6), cmap = 'coolwarm')

# 그래프 옵션
        ax.set_title(f'Stacked Bar Plof of {self.feature} vs {self.target}')
        ax.set_ylabel('Proportion')
        ax.set_xlabel(self.feature)
# plt.show()

plot = StackedBarplot(train, 'loan_intent')
plot.plot()

st.pyplot(fig)

if __name__ == "__main__":
    main()



"""