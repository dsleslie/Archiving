import streamlit as st
import tensorflow as tf
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications.mobilenet_v2 import MobileNetV2, preprocess_input, decode_predictions
import numpy as np
from PIL import Image
import io
import plotly.express as px

# 페이지 설정
st.set_page_config(page_title="Image Classification App", layout="wide", menu_items={
    'Get Help': 'https://www.tensorflow.org/tutorials/images/classification',
    'Report a bug': None,
    'About': "Image Classification App using MobileNetV2"
})

# 제목과 설명을 컨테이너에 담기
with st.container():
    st.title("Image Classification with MobileNetV2")
    st.write("이 앱은 사전 학습된 MobileNetV2 모델을 사용하여 이미지를 분류합니다.")

# 사전 학습된 모델 로드
@st.cache_resource
def load_model():
    return MobileNetV2(weights='imagenet')

model = load_model()

# 메인 컨테이너 생성
main_container = st.container()

with main_container:
    # 이미지 업로드
    uploaded_file = st.file_uploader("이미지를 선택하세요...", type=["jpg", "jpeg", "png"])

    if uploaded_file is not None:
        # 업로드된 이미지 표시
        img = Image.open(uploaded_file)
        # RGB 모드로 변환
        img = img.convert('RGB')
        st.image(img, caption='업로드된 이미지', use_column_width=True)
        
        # 모델을 위한 이미지 전처리
        img = img.resize((224, 224))
        x = image.img_to_array(img)
        x = np.expand_dims(x, axis=0)
        x = preprocess_input(x)
        
        # 예측 수행
        if st.button('이미지 분류하기', use_container_width=True):
            with st.spinner('분류 중...'):
                preds = model.predict(x)
                decoded_preds = decode_predictions(preds, top=5)[0]
            
            # 예측 결과를 컨테이너에 표시
            with st.container():
                st.subheader("예측 결과:")
                col1, col2 = st.columns(2)
                
                with col1:
                    for i, (imagenet_id, label, score) in enumerate(decoded_preds):
                        st.write(f"{i + 1}. {label}: {score:.2%}")
                
                # 예측 결과의 막대 차트 생성
                with col2:
                    labels = [pred[1] for pred in decoded_preds]
                    scores = [pred[2] for pred in decoded_preds]
                    
                    fig = px.bar(
                        x=scores,
                        y=labels,
                        orientation='h',
                        title='예측 신뢰도 점수',
                        labels={'x': '신뢰도', 'y': '클래스'}
                    )
                    st.plotly_chart(fig, use_container_width=True)

    # 샘플 이미지 섹션
    with st.container():
        st.subheader("또는 샘플 이미지로 시도해보세요")
        sample_imgs = {
            "군인": "https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/lite/examples/label_image/testdata/grace_hopper.bmp",
            "강아지": "https://storage.googleapis.com/download.tensorflow.org/example_images/YellowLabradorLooking_new.jpg"
        }

        selected_sample = st.selectbox("샘플 이미지 선택:", list(sample_imgs.keys()), key='sample_select')

        if st.button("샘플 이미지 분류하기", use_container_width=True):
            with st.spinner('다운로드 및 분류 중...'):
                # 샘플 이미지 다운로드 및 처리
                import requests
                response = requests.get(sample_imgs[selected_sample])
                img = Image.open(io.BytesIO(response.content))
                img = img.convert('RGB')
                st.image(img, caption=f'샘플 {selected_sample} 이미지', use_container_width=True)
                
                # 이미지 전처리
                img = img.resize((224, 224))
                x = image.img_to_array(img)
                x = np.expand_dims(x, axis=0)
                x = preprocess_input(x)
                
                # 예측 수행
                preds = model.predict(x)
                decoded_preds = decode_predictions(preds, top=5)[0]
                
                # 예측 결과를 컨테이너에 표시
                with st.container():
                    st.subheader("예측 결과:")
                    col1, col2 = st.columns(2)
                    
                    with col1:
                        for i, (imagenet_id, label, score) in enumerate(decoded_preds):
                            st.write(f"{i + 1}. {label}: {score:.2%}")
                    
                    # 예측 결과의 막대 차트 생성
                    with col2:
                        labels = [pred[1] for pred in decoded_preds]
                        scores = [pred[2] for pred in decoded_preds]
                        
                        fig = px.bar(
                            x=scores,
                            y=labels,
                            orientation='h',
                            title='예측 신뢰도 점수',
                            labels={'x': '신뢰도', 'y': '클래스'}
                        )
                        st.plotly_chart(fig, use_container_width=True)

# 사용 설명을 컨테이너에 담기
with st.container():
    st.markdown("""
    ### 앱 사용 방법:
    1. 위의 파일 업로더를 사용하여 이미지를 업로드하거나 샘플 이미지를 선택하세요
    2. '이미지 분류하기' 버튼을 클릭하세요
    3. 상위 5개 예측 결과와 신뢰도 점수를 확인하세요

    이 모델은 ImageNet으로 사전 학습된 MobileNetV2를 사용하며 1000개의 다양한 카테고리로 이미지를 분류할 수 있습니다.
    """)

# 푸터 추가
st.markdown("---")
st.markdown("Streamlit과 TensorFlow로 제작됨", unsafe_allow_html=True)


