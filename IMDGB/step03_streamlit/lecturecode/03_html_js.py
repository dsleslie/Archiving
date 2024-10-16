# -*- coding: utf-8 -*-

import streamlit as st 
import streamlit.components.v1 as components

def main():
    st.markdown("HTML JS Streamlit 적용")
    js_code = """ 
    <h3>Hi</h3>

    <script>
    function sayHello() {
        alert('Hello from JavaScript in Streamlit Web');
    }
    </script>

    <button onclick="sayHello()">Click me</button>
    """
    components.html(js_code)







if __name__ == "__main__":
    main()