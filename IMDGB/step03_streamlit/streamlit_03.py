# -*- coding: utf-8 -*-
import pandas as pd 
import seaborn as sns
import streamlit as st
import matplotlib.pyplot as plt

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
"""

@st.cache_data
def load_data():
    train = pd.read_csv('c:/Archiving/IMDGB/step03_streamlit/data/train.csv')
    return train

def main():
    st.title("Explatory Data Analysis")   
    train = load_data()

    import matplotlib.pyplot as plt

    class StackedBarplot:                                       # StackedBarplot 클래스
    def __init__(self, df, feature, target='loan_status' ): # init 메서드
        self.df = df
        self.feature = feature
        self.target = target

    def plot(self):                                         # plot 메서드
    # crosstab 생성
        crosstab = pd.crosstab(self.df[self.feature], self.df[self.target], normalize='index')
        ax = crosstab.plot(kind = 'bar', stacked = True, figsize = (12,6), cmap = 'coolwarm')

    # 그래프 옵션
    ax.set_title(f'Stacked Bar Plof of {self.feature} vs {self.target}')
    ax.set_ylabel('Proportion')
    ax.set_xlabel(self.feature)
    # plt.show()


    plot = StackedBarplot(df_train, 'loan_intent')
    plot.plot()

    st.pyplot(fig)

if __name__ == "__main__":
    main()