---
layout: post  
comments: true    
title: opencv 를 이용한 얼굴 인식
tags: [opencv, c]
---
영화 "마이너리티 리포트" 를 보면 주인공이 손동작을 통해 컴퓨터의 파일이나 오브젝트를 조작 하는걸

볼수 있다. 비단 공상과학 영화에서나 가능할거라고 믿었던 그때의 그 장면이 컴퓨터가 발달하고 고급 프로그램

언어들이 개발됨에 따라 약간의 지식이 있는 사람이라면 누구나 쉽게 도전해 볼수 있는 상황에 이르게 된것이다.

이번에 개발해 보려고 하는 부분은 분류를 나누자면 "영상처리" 가 되겠고 그중에서 손모양 인식 및 객체 컨트롤

이 될것이다. 아직 실력이 많이 부족하지만 열심히 해서 안되는게 어디 있겠는가!

일단 개발 준비과정이 필요하다.
Visual Studio 6.0  (2008 버젼보다 6.0 + 서비스팩2 가 더 가벼운 느낌이..;;)
OpenCv 1.1 (더 상위 버젼이 있지만 1.1 버젼에 대한 설정이 더 쉬운것 같아서;;)
웹캠 (다들 여러가지 캠을 추천해줬지만 노트북에 달려있는 막캠을 활용해 본다)

개발언어는 C 를 이용해서 진행 할것이다.

개발과정은 아래와 같다.
1. OpenCv 설치 후 VS6.0 에 C 프로젝트 생성후 프로젝트 셋업에 OpenCv 라이브러리를 등록한다.
2. OpenCv 제공 기본함수를 통해 캠에서 영상을 실시간으로 출력한다.
3. 출력되는 영상의 RGB 값을 추출한다.
4. 추출한 RGB 값을 YCbCr 값으로 변환후 살색값만을 필터링 한다.
5. 추출된 살색영상을 이용하여 손모양을 찾는다.
6. 손의 모양(주먹을 쥐고 있는지 손을 펴고 있는지)을 인식, 손의 방향을 인식한다.

영상처리 특히 손모양 같은건 단조로운 배경, 또는 손만을 인식하는 등의 야매(?) 가 존제 하지만

일단은 어떤 환경에서도 동작이 가능하도록 하는것을 목표로 개발해 보도록 하자..@_@;;

위의 1번 같은 경우는 검색만 하면 쉽게 알수 있는 내용이기 때문에 자세한 설명은 생략!;;
일단 오늘은 여기까지 입니다..;;

Step.0 에서 말한대로 개발과정에 맞춰서 구현을 해 보도록 하자.

이번에 해야 할일은 단순하게 노트북에 부착되어진 캠으로 실시간 화상을 받아 출력하는 것이다.

OpenCv 라이브러리 함수를 등록하는 과정을 Step.0 에서도 말했듯이 검색하면 많이 나오기 때문에 생략 하도록 하겠다.

일단 소스를 보면 아래와 같다.

// 파일명 : opencv_test.c

#include <cv.h>
#include <cxcore.h>
#include <highgui.h>
#include <stdio.h>

int main(){
 IplImage* image = 0;   // 웹캠에서 받아온 이미지가 저장될 구조체
 CvCapture* capture = cvCaptureFromCAM(0); // 캡춰할 장치를 연결
 cvNamedWindow("color",0);  // 이미지를 출력해줄 창 생성
 cvResizeWindow("color",350,350); // 창의 크기를 설정
 cvGrabFrame( capture );  // 웹캠에서 이미지 캡춰

 image = cvRetrieveFrame( capture ); // 캡춰된 이미지를 image 구조체에 넣는다.

while(1) {
  cvGrabFrame( capture );
  image = cvRetrieveFrame( capture );

  cvShowImage("color",image); // color 라는 이름의 창에 image 를 출력

if( cvWaitKey(10) >= 0 ) break;
 }
cvReleaseCapture( &capture ); // 메모리 해제
cvDestroyWindow( "color" );
}

실행 결과 화면은 아래와 같다.

![](https://drive.google.com/uc?export=download&id=1t-QR4cjQpJmAysk7l__d-OXuInc-0QJw)

얼굴부분은 웃기게 나와서 편집 했습니다..;;

아무튼 위처럼 부착된 웹캠으로 영상을 받아 화면에 출력 해보았다.

아직까지는 OpenCv 에서 제공해주는 함수들 만으로 구현했기 때문에~ 그렇게 큰 어려움은 없었다.

Step.1 에서 OpenCv 에서 제공되는 기본적인 함수를 이용하여 웹캠으로 영상을 입력받고~

그걸 다시 윈도우창을 뛰워서 출력하는 프로그램을 제작 해보았다.

이번에 해야할 과정은 입력받은 영상의 각 픽셀당 RGB 값을 추출하고 피부색을 검출하는것 입니다.

int i, j;  // 이미지의 가로세로
unsigned char r=0, g=0, b=0;  // 0~255 까지의 값을 받는 각각의 변수

for(i=0; i<image->height; i++){ // 이미지의 높이만큼 반복
for(j=0; j<image->width; j++){ // 이미지의 넓이 만큼 반복
r=(unsigned char)image->imageData[(i*image->widthStep)+j*3+2]; // Red값
g=(unsigned char)image->imageData[(i*image->widthStep)+j*3+1]; // Green값
b=(unsigned char)image->imageData[(i*image->widthStep)+j*3+0]; // Blue값
if((r > 120) && (g > 80) && (b > 50)){ // 살색으로 검출된 부분을 하얀색으로 변환

image->imageData[(i*image->widthStep)+j*3+2] = 255;
image->imageData[(i*image->widthStep)+j*3+1] = 255;
image->imageData[(i*image->widthStep)+j*3+0] = 255;
}
else{  // 살색으로 검출되지 않은 색은 검정색으로 변환
image->imageData[(i*image->widthStep)+j*3+2] = 0;
image->imageData[(i*image->widthStep)+j*3+1] = 0;
image->imageData[(i*image->widthStep)+j*3+0] = 0;
}
}

}

위의 코드에서 사용된 RGB 값은 국내 논문에 공개된 백인종, 흑인종, 황인종의 피부색을 각각 RGB 값으로 범위를 제한

하여 만들어진 표를 보고 작성 한것이다.

표에 의하면 백인종, 흑인종, 황인종의 피부색 값은 아래와 같았다.  R > X  G > Y  B > Z  백인종 210 150 110 흑인종 60 40 20 황인종 120 80 50
하지만 위의 표대로 결과값을 뽑게 되면 의도하지 않은 화면을 보게 된다.

![](https://drive.google.com/uc?export=download&id=1fPdMpa-8y7h2xretFyapSNA7MgQWGZnb)

(왼쪽 영상의 초상권 보호를 위해 블러링 처리 하였습니다..ㅎ_ㅎ;;)

오른쪽 영상은 피부색으로 판별된 부분은 하얀색, 그렇지 않은 부분은 검정색으로 이진화 시켜 출력한 영상 이다.

영상에서 보듯이 피부로 검출된 색이 얼굴 이외에도 주위 배경까지 포함하게 되어 있다.

살색이 아니지만 RGB 값의 범위로 인하여 살색으로 판정이 된 부분이라고 할수 있겠다.

위의 영상에서 조금더 살색의 범위를 좁히고 싶다면 R > 120 , G > 80 , B > 50 으로 하한선이 정해진 상태에서 추가적으로

각각 R, G. B값을 설정할 필요가 있다.

위의 논문에서 정의한 표에는 R, G, B값의 상한선이 없었다.

즉.. 박복적으로 살색이 아닌곳과 살색인 곳의 RGB 값을 추출하여 비교하여 RGB값의 상한선을 정해야 한다는 것이다.

물론 많은 양의 표본을 조사하여 상한선을 정한다면 확실히 더 좋은 품질의 결과 값을 얻을수 있지만

원하는 만큼의 결과는 얻을수 없었다.

위의 결과를 토대로 더 좋은 품질의 결과 값을 얻기 위한 방법으로 RGB 값을 이용한 피부색 검출법이 아닌

YCbCr 의 컬러모델을 이용하여 피부색을 검출 하는 방법을 시도해 볼 예정이다.

이번에는 Step.2 에서 있었던 불안정한 피부색 추출을 해결하기 위해 추출된 RGB 모델에서 약간의 연산을 통해

YCbCr 값을 구하고 그 값을 이용하여 피부색을 추출해 보도록 하겠다.
- -

Step.2 의 소스에  y, cb, cr 값을 구하는 부분과 if 문에서 y, cb ,cr 로 살색을 검출하는 부분을 추가했다.

![](https://drive.google.com/uc?export=download&id=1sRhe5zI6fvUvDOjHEwLShnAYgs12m8ze)

YCbCr 값으로 검출된 영상이 RGB 값으로 검출된 영상보다 훨씬 좋은 결과를 보여주고 있다.

물론 얼굴부위 임에도 불구하고 왼쪽 볼부분이 약간 검출되지 않은 부분이 있다.

또한 얼굴을 제외한 나머지 부분들이 검정색으로 처리 되지 않고 잡음이 생긴것을 볼수 있다.

이를 해결하기 위해서 모폴로지 연산중 4방향 침식 연산을 수행하여 이를 해결하고자 하였다.      ■           ■           ■           ■           ■      ■ ■ ■ ■ ■ ■  ■ ■ ■ ■ ■      ■           ■           ■           ■           ■     
위의 표처럼 빨간 픽셀을 기준 픽셀로 하여 상,하,좌,우 각각 10개의 픽셀(그림에서는 5개만 표시했음)을 검사하여

피부색으로 추청되는 픽셀이 있는지의 유무를 확인 한다.

만약 살색으로 추정되는 픽셀이 기준 픽셀을 중심으로 20개 이상 된다면 기준 픽셀의 값을 그대로 유지하고

그렇지 않다면 기준 픽셀을 잡음으로 판단하여 배경처리( 검정색으로 변환 ) 한다.
- -
YCbCr 로 영상을 검출한후 4방향 모폴로지 연산을 한후의 결과는 아래와 같다.

![](https://drive.google.com/uc?export=download&id=1tuf8uQupwYYgMxNzvNu7BzzBYNwisYnx)

위의 영상에 왼쪽위의 룸메이트의 얼굴은 결과값에서 제외 하였다;;

어쨋든 결과를 보면 오른쪽과 같이 얼굴 부분이서 잡티로 처리되어 빠져나간 부분이 다소 있기는 했지만 배경 부분의
잡음이 깔끔하게 제거 된것을 볼수 있다.