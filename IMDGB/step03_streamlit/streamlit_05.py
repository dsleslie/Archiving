# -*- coding: utf-8 -*-
import streamlit as st 
import pandas as pd 

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






if __name__ == "__main__":
    main()
