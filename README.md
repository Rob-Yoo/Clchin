# 클친
<br>

클라이밍 소셜 커뮤니티 어플리케이션

<br>

## 🗄️ 프로젝트 정보
- **기간** : `2024.08.13 ~ 2024.09.02` (약 2주)
- **개발 인원** : `iOS 1명`
- **지원 버전**: <img src="https://img.shields.io/badge/iOS-15.0+-black?logo=apple"/>
- **기술 스택 및 라이브러리** :      
  - UI: `UIKit` `Webkit` `PhotosUI` `SnapKit` `Cosmos` `NMapsMap`
  - Reactive: `RxSwift` `RxCocoa` `RxGesture` `RxDataSources` `RxCoreLocation`
  - Network: `Moya` `Kingfisher` `GooglePlaces`
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


## 🧰 프로젝트 주요 기술 사항

### 아키텍처 - Clean Architecture + MVVM
<img width="916" alt="Clean-Architecure" src="https://github.com/user-attachments/assets/1ea31654-2485-479e-b93d-75b73f29f749">

- Data 계층

  - Repository: 외부 데이터소스 접근 작업
 
  - DTO: Entity 매핑 작업

- Domain 계층

  - UseCase: Repository를 조합하여 통합된 Entity 생성 및 가공

- Presentation 계층

  - ViewModel, ViewController: Rx와 Input-Output 패턴을 사용하여 데이터 바인딩에 의한 뷰 업데이트
 
  - Presentation Model: Passive View를 위한 데이터 모델

<br>

### JWT 토큰 관리

- UserDefaults에 Access 토큰과 Refresh 토큰 저장

- Alamofire의 `RequestInterceptor`의 retry 메서드를 통해 토큰 재발급 로직 구현

<br>


### 커서 기반 페이지네이션

- 페이지네이션 관련 상태값은 Repository에서만 관리

  - 마지막 페이지일 경우 네트워크 요청하지 않게 처리

  - ViewModel과 UseCase에서는 페이지네이션 여부만 인지

<br>

### 사용자의 위치 권한 변경에 따른 위치 정보 자동 업데이트 

- Observable.create 문 내에서 `denied`에서 `authorizedWhenInUse`으로 변경을 감지하고 사용자의 위치 정보를 방출

<br>

### API 별 네트워크 에러 상태코드 관리

- API 별 커스텀 에러 타입에 ErrorMapping이라는 프로토콜을 만들어 채택

  - map(statusCode: Int) 메서드를 구현하여 상태코드에 맞는 case 반환

<br>

### 결제

- PG사를 웹뷰에 띄워 결제 진행

- 사용자의 결제 관련 어뷰징 방지를 위해 서버로부터 결제 검증 작업을 요청하여 최종 결제 완료 판단

<br>

### 사진 업로드 및 로드

- `PHPickerViewController`를 사용하여 사진 보관함으로부터 사진 선택 기능 구현

- multipart/form-data 업로드

- Kingfisher의 `AnyModifier`를 사용하여 `Access 토큰이 필요한 이미지 로드` 기능 구현

<br>
  

## 🚨 트러블 슈팅

### 1. RequestInterceptor의 retry 메서드 무한 호출 이슈

- 원인 분석

  - Moya의 `NetworkLoggerPlugin`을 사용하여 Request Header를 확인한 결과 이전 토큰을 그대로 사용

  - retry 메서드가 호출될 때 TargetType에 정의된 Request를 새로 만드는 것이 아니라고 판단
 
- 해결

  - AccessToken을 TargetType의 헤더에 넣어주는 것이 아니라 RequestInterceptor의 `adapt` 메서드를 사용하여 Request Message를 보내기 전 토큰을 삽입하는 방식으로 해결

<br>

### 2. flatMap 내부에서 onError가 방출되면 전체 스트림이 끊기는 문제

- 해결 과정

  - flatMap 내부에서 catch를 사용해서 에러 핸들링을 하려 했으나 다양한 커스텀 에러 이벤트를 방출하지 못함
 
  - single(.failure(error)) 형태로 커스텀 에러 이벤트도 방출하려 했으나 failure시 Single이 onError를 방출하기 때문에 스트림이 끊김

  - `single(.success(.failure(error)))` 형태로 방출하여 스트림이 끊기지 않고도 커스텀 에러 이벤트를 방출할 수 있게됨

<br>

### 3. PublishSubject 특성에 의해 Output에 대한 subscribe 문이 동작하지 않는 문제

- 해결 과정

  - Hot/Cold Observable 관련 문제라 판단하여 PublishSubject에서 Observable로 변경

    - 한번 이벤트를 방출하고 난 후 Dispose 되어 스트림이 끊겨버림
   
  - 이를 해결하기 위해 subscribe 시점 이전 이벤트를 전달받을 수 있는 Subject가 필요
 
    - `BehaviorSubject`를 사용하여 위의 모든 문제를 해결

<br>

## 📋 회고

### 1. Domain 계층에서 GooglePlace 라이브러리를 import 한 것에 대한 아쉬움

- UseCase가 아닌 Repository에서 모든 것을 담당하게 하여 라이브러리가 교체되었을 때의 변화가 Domain 계층까지 전파되지 않게 했었어야 한다는 생각

- Entity에 이미지 관련 GooglePlace 타입이 존재하는데, DTO와 Entity 변환 과정에서 Data 타입으로 변환해줬어야 한다는 생각

<br>

### 2. DI Container 사용에 대한 필요성

- ViewController를 하나 생성하려면 외부에서 VM, UseCase, Repository 객체를 일일히 생성해서 주입시켜줘야 함

- Swinject이나 직접 DI Container를 구현해서 사용해봐야겠다는 생각 
