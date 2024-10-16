# -*- coding: utf-8 -*-

import streamlit as st 

def main():
    st.title("This is Text Elements")
    st.header("This is Header/헤더")
    st.subheader("This is sub Header")
    st.write("파이썬 문법 사용 가능")
    st.write("-" * 50) # print()
    st.markdown(""" 
    ## Chapter 1. 
    - 색상 테스트 : This text is :red[colored red], and **:blue[colored]** and bold.
    """)
    st.markdown(""" 
    ### SubChapter 1. 
    - 피타고라스 정리 : :red[$\sqrt{x^2+y^2}=1$] is a Pythagorean identity. :pencil:
    """)
    st.markdown("## Chapter 2. \n"
                "- Streamlit is **_really_ cool**.\n"
                "   * This text is :blue[colored blue], and this is **:red[colored] ** and bold.")
    

if __name__ == "__main__":
    main()