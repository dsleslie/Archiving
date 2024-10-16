# -*- coding: utf-8 -*-
import streamlit as st 
import pandas as pd 
import requests

def main():
    st.title("API도 되나?")

    SERVICE_KEY = 'QN54WqiBTYKQUzG7FaY62TgZxUdM9KMZYwkjIAelmD062qWigUT4Tlj%2B%2BNoqgaLcvdqvqNvfZqP92%2Flwn5gB5A%3D%3D'
    loanYM=202307
    numOfRows=10
    pageNo=1
    dataType="json"
    cbGrd=1
    jobCd="01"
    houseTycd="06"
    age="3"
    income="2"
    debt="2"


    url = f'http://apis.data.go.kr/B551408/rent-loan-rate-multi-dimensional-info/dimensional-list?serviceKey={SERVICE_KEY}&loanYm={loanYM}&numOfRows={numOfRows}&pageNo={pageNo}&dataType={dataType}&cbGrd={cbGrd}&houseTycd={houseTycd}&jobCd={jobCd}&age={age}&income={income}&debt={debt}'
    req = requests.get(url)
    print(url)
    content = req.json()
    df=pd.DataFrame(content)

    st.write(df.head())
    







if __name__ == "__main__":
    main()



