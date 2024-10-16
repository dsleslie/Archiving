# -*- coding: utf-8 -*-
import streamlit as st 
import pandas as pd 
import datetime
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

def cal_sales_revenue(price, total_sales):
    revenue = price * total_sales
    return revenue

def main():
    st.title("여기에서부터 시작")
    price = st.slider("단가 : ", 1000, 10000, value=5000)
    st.write("price :", price)
    total_sales = st.slider("판매갯수 : ", 1, 1000, value=500)
    print(price, total_sales,)
    st.write("total stales :", total_sales)
    print(type(price))

    if st.button("매출액 계산"):
        revenue = cal_sales_revenue(price, total_sales)
        st.write(revenue)

    # 인풋 위젯이라고 함.


    st.title('Check Box Control')
    x = np.linspace(0, price, total_sales)
    y = np.sin(x)
    show_plot = st.checkbox("시각화 보여주기")
    print(show_plot)
    if show_plot:
        fig, ax = plt.subplots()
        ax.plot(x,y)
        st.pyplot(fig)


    st.title('Check Box Control')
    x = np.linspace(0, price, total_sales)
    y = np.sin(x)
    x = np.cos(x)
    show_plot = st.checkbox("시각화 보여주기")
    print(show_plot)
    if show_plot:
        fig, ax = plt.subplots()
        ax.plot(x,y)
        ax.plot(x,z)
        st.pyplot(fig)

    """
    st.title("내 생일")
    d = st.date_input("When's your birthday", datetime.date(2019, 7, 6))
    st.write("Your birthday is:", d)

    st.title("CHAT")
    prompt = st.chat_input("Say something")
    if prompt:
        st.write(f"User has sent the following prompt: {prompt}")

    

    def load_data():
        train = pd.read_csv('c:/Archiving/IMDGB/step03_streamlit/data/train.csv')
        return train

    st.title("그래프 연습")
    train = load_data()

    fig, ax = plt.subplots(nrows = 1, ncols = 1, figsize=(10, 6))
    ax = sns.countplot(data=train, x='cb_person_default_on_file', hue='loan_status')
    ax.set_title("Loan Default by Prior Default Status")
    #plt.show()
    st.pyplot(fig)
    """


if __name__ == "__main__":
    main()
