import os
# Visualization Module for Python
import matplotlib.pyplot as plt
# Python Image Library
from PIL import Image

# 현재 디렉터리 변경
os.chdir(r"C:/Users/daess/Desktop/VOC2007")

# 수정한 사진과 xml 파일을 구분하고자 VOC2007 폴더에 새로운 폴더 flip_image와 flip_annotations 생성

# JPEGImages 불러오기
image_file =  os.listdir("./JPEGImages")

# 사진 뒤집기
# 좌우변환한 사진은 VOC 2007 폴더 내 flip_image 폴더에 저장

# 사진 뒤집기

for _file in image_file:
    path = "JPEGImages/" + _file # 사진 경로 생성
    image = Image.open(path) # 사진 열기
    method_ = Image.FLIP_LEFT_RIGHT 
    flip = image.transpose(method_) # 사진 뒤집기
    name = _file[0:6] 
    # 사진 이름 뒤에 '-a'를 붙이고자 image_file에서 사진 이름만 분리
    # 모든 image_file에서 사진의 이름은 파이썬 기준 0번째부터 5번째에 있음
    flip.save('flip_image/' + name + '-a.jpg')
    # '+'를 이용하여 문자열과 사진의 이름 정보를 가진 name 변수 연결하여 뒤집은 사진 저장


# Annotation 불러오기 
import xml.etree.ElementTree as Et

xml_file =  os.listdir("./Annotations")

# Annotation 수정
# 수정한 Annotation은 VOC 2007 폴더 내 flip_annotations 폴더에 저장
# 사진의 좌우변환을 하였기 때문에 사진 속 object의 x좌표(xmin, xmax)들만 바뀜
# x축의 중심, 즉 사진의 너비의 중심을 기준으로 바뀌기 때문에 size 태그에서 width 태그만 필요

for _file in xml_file: # Annotations 폴더 내 xml 파일들을 차례대로 불러오기
    xml_path = "./Annotations/"+ _file # xml 파일 경로 생성
    xml_open = open(xml_path, mode = 'r', encoding="utf-8") # xml 파일 열기
    xml_tree = Et.parse(xml_open) # xml객체로 파싱하기
    _root = xml_tree.getroot() # xml 파일 내 최상위 태그(annotation) 가리킴
    objects = _root.findall('object') # xml 파일 내 모든 object 태그 찾기
    file = _root.find('filename').text # xml 파일 이름 정보를 알고자 filename 태그의 text 추출
    name = file[0:6] # xml 파일 이름 추출(확장자 제외)
    size = _root.find('size') # xml 파일 내 size(사진 크기) 태그 찾기
    width = int(size.find('width').text) # 좌우변환을 위한 annotation 수정에서 width만 필요
    
    for _object in objects: # 각 xml 내 모든 object들을 차례대로 불러오기
        bndbox = _object.find('bndbox') # object의 xmin과 xmax 태그를 포함한 bndbox 태그 찾기
        
        # object의 xmin과 xmax 태그의 text 추출
        # text의 type을 확인하면 문자형이기 때문에 계산을 위해 정수형으로 변환
        xmin = int(bndbox.find('xmin').text) 
        xmax = int(bndbox.find('xmax').text)
        
        # 좌우변환하면 중심을 기준으로 object의 위치(좌측, 우측)에 상관없이
        # 좌우변환한 object의 xmin은 { 2*중심(= 너비) - 원래 xmax },
        # 좌우변환한 object의 xmax는 { 2*중심(= 너비) - 원래 xmin }임
        f_xmin = width - xmax
        f_xmax = width - xmin
        
        # 수정한 xmin과 xmax로 바꾸기 위해 문자형으로 변환후 저장
        bndbox.find('xmin').text = str(f_xmin)
        bndbox.find('xmax').text = str(f_xmax)
    
    # 수정한 xml 파일 저장
    xml_tree.write('./flip_annotations/'+ name + '-a.xml')
    

