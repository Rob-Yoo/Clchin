# 클친
<br>

클라이밍 소셜 커뮤니티 어플리케이션

<br>

## 🗄️ 프로젝트 정보
- **기간** : `2024.08.13 ~ 2024.09.08` (약 3주)
- **개발 인원** : `iOS 1명`
- **지원 버전**: <img src="https://img.shields.io/badge/iOS-15.0+-black?logo=apple"/>
- **기술 스택 및 라이브러리** :      
  - UI: `UIKit` `Webkit` `PhotosUI` `SnapKit` `Cosmos` `NMapsMap`
  - Reactive: `RxSwift` `RxCocoa` `RxGesture` `RxDataSources` `RxCoreLocation`
  - Network: `Moya` `Kingfisher` `GooglePlaces`
  - 결제: `iamport-ios`
  - 기타: `Then`
- **프로젝트 주요 기능**

  - `SNS 피드 기능`
  
    - 피드 조회 / 작성 / 수정 / 삭제 기능
  
  - `클라이밍장 검색 기능`
      
      - 실시간 검색 기능
        
      - 사진 / 이름 / 주소 / 평점 / 평점인원 / 사용자와의 거리 / 영업 여부 / 영업 시간 정보 제공 기능

        
      - 지금 영업 중 / 거리순 / 평점순 다중 필터링 및 정렬 기능

      - 전화 걸기 / 네이버 지도 앱 연동 길찾기 / 인스타그램 웹페이지 연동 기능

      - 네이버 지도를 활용한 클라이밍장 위치 확인 기능
  
  - `클라이밍 크루 모집 기능`

    - 크루 모집 포스트 조회 / 작성 기능

    - 참가비 결제 기능

<br>


| 피드 화면 | 클라이밍장 검색 화면 | 클라이밍장 상세 화면 | 크루 모집 화면 | 크루 모집 상세 화면 |
|--|--|--|--|--|
|![피드화면](https://github.com/user-attachments/assets/96f1803f-6989-4293-90d3-2ee439361280)|![암장검색화면](https://github.com/user-attachments/assets/251ac67e-f186-4dc9-be7a-94c84e176b7d)|![암장상세화면](https://github.com/user-attachments/assets/86e150f9-4abc-4215-9804-b21fea25e06d)|![크루모집리스트](https://github.com/user-attachments/assets/715a46f6-de79-40b9-8a68-64b1eca6742b)|![크루모집상세](https://github.com/user-attachments/assets/144c09be-aea6-4823-9a89-43241276cdbd)|


<br>



## 🧰 프로젝트 기술 사항

### 아키텍처 - Clean Architecture + MVVM
<img width="916" alt="Clean-Architecure" src="https://github.com/user-attachments/assets/1ea31654-2485-479e-b93d-75b73f29f749">

### AccessToken 갱신

- Alamofire의 `RequestInterceptor` 사용



## 🚨 트러블 슈팅



