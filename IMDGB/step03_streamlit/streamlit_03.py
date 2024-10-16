# -*- coding: utf-8 -*-
import pandas as pd 
import seaborn as sns
import streamlit as st
import matplotlib.pyplot as plt



@st.cache_data
def load_data():
    train = pd.read_csv('c:/Archiving/IMDGB/step03_streamlit/data/train.csv')
    return train

def main():
    st.title("EDA")

    fig, ax = plt.subplots(nrows = 1, ncols = 1, figsize=(10, 6))
    ax = sns.countplot(data=df_train, x='person_home_ownership')
    ax.set_title("Distribution of Loan Applicants by Home Ownership")
    #plt.show()  

    st.pyplot(fig)

if __name__ == "__main__":
    main()


