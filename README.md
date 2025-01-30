### Develpoment Environment
```
Minimum Deployments: iOS 15.0
Xocde Version: 16.2
```

**외부 라이브러리**
```
KingFisher
```

---
### Skill Stack
- Development: SwiftUI
- Architecture : Clean Architecture + MVVM

### Architecture 선정 이유
`의존성 관리`  
역할별로 명확한 layer를 구분하여 각 layer는 독립적으로 동작하기 때문에 특정 기능을 수정하거나 추가할때도 다른 layer에 영향을 주지않고 관련된 부분만 수정하면 됨

`변경 용이`  
프로토콜(인터페이스)를 사용함으로써 새로운 기능이나 모듈을 추가할 때, 기존 코드에 최소한의 영향을 주면서 쉬운 확장이 가능함

`확장성`  
DI를 통해 각 레이어는 프로토콜로(인터페이스) 소통하기 때문에 결합도가 낮아지며, 의존성 관리에 유연함  

`독립성`  
각 레이어의 독립적인 동작이 가능하기 때문에, UI나 데이터의 접근 방식이  변경되어도 도메인 레이어는 변경없이 사용할 수 있음  

`가독성`  
각 레이어의 책임을 명확하게 정의하고 역할을 분리하여 코드의 가독성을 높임
새로운 팀원이 프로젝트에 합류했을 때 쉽게 이해할 수 있음

<img src="https://raw.githubusercontent.com/syss220211/Union/refs/heads/develop/Union/images/architecture.png" >

### Layer 구현 내용
`Application Layer`
- AppDelegate, SceneDelegate 위치  
- 애플리케이션의 진입점으로써 실행과 관련된 작업을 처리함 
- 다른 레이어 간의 의존성을 관리함  

`Data Layer`  
- 외부 데이터 소스와의 상호작용을 담당하는 레이어  
- APIService가 위치하며 네트워크 작업이 이루어짐  
- DTO로 받아오며 Mapper를 통해 앱 내부에 맞는 데이터로 변환하여 사용  

`Domain Layer`  
- 비즈니스 로직을 처리하는 핵심 레이어   
- Entity, Usecase, Repository Protocol 를 정의하고 사용  
- 외부 데이터 소스나 UI에 의존하지 않고 순수한 비즈니스 로직만을 포함함  

`Presentation Layer`  
- UI와 관련된 모든 요소를 처리하는 레이어  
- MVVM 패턴의 ViewModel이 포함됨  
- 사용자 인터페이스 로직을 처리하며 Domain레이어와 상호 작용을 통해 UI를 업데이트함  

`Design System Module`  
- 디자인과 관련된 파일, 소스들이 모여있는 모듈  
- 비즈니스 로직과 연관 없이 디자인만 정의되어 있는 모듈

---
### Main Features
- 로그인
	- 투표화면으로 가기 위한 닉네임 입력
- 투표
	- 투표 관련 정보 확인
	- 후보자 리스트 확인 (무한 스크롤 가능)
	- 투표
- 투표자 상세
	- 투표자 상세 정보 확인
	- 투표

## Network
 ```swift
    func request<T: Decodable>(
        target: TargetType
    ) -> AnyPublisher<T, NetworkError> {
```
- request 수행 시, TargetType을 입력받음

```swift
protocol TargetType {
    var url: String { get }
    var method: HTTPMethod { get }
    var path: String? { get }
    var query: Encodable? { get }
    var body: Encodable? { get }
}
```
- TargetType에는 request에 필요한 정보들이 명시되어있음
- 각 피처의 요청을 하나의 열거형에 정리하여 간단하기 관리하기 위하여 해당 방법을 사용함
  
[실제 VoteType 구현]
```swift
enum VoteType: TargetType {
    /// 후보자 상세 정보 조회
    case getCandidateDetailInfo(candidateID: Int, voterID: String)
    /// 후보자 목록 조회
    case getCandidateList(pageable: PageableRequestDTO)
    
    var url: String {
        switch self {
        case .getCandidateDetailInfo:
            return EndPoint.getCandidateDetail.url
        case .getCandidateList:
            return EndPoint.getCandidateList.url
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCandidateDetailInfo, .getCandidateList, .getVotedCandidateList:
            return .get
        case .postVote:
            return .post
        }
    }
    
    var query: Encodable? {
        switch self {
        case .getCandidateDetailInfo(_, let voterID):
            return ["userId" : voterID]
        case .getCandidateList(let pageable):
            return pageable
        }
    }
    
    var path: String? {
        switch self {
        case .getCandidateDetailInfo(let candidateID, _):
            return "\(candidateID)"
        case .getCandidateList:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case .getCandidateDetailInfo, .getCandidateList:
            return nil
        }
    }
}

```
사용 시 간단하게 사용 가능
```swift
  /// 후보자 상제정보   조회
    func getCandidateDetailInfo(request: VoteType) -> AnyPublisher<CandidateDetailEntity, NetworkError> {
        return networkService.request(target: request)
            .tryMap { dto in
                CandidateDetailMapper.toCandidateDetail(response: dto)
            }
            .mapError{ error in
                return NetworkError.badMapper
            }
            .eraseToAnyPublisher()
    }
```

## App Images
| `홈`                                                                                                                                 | `후보자 목록`                                                                                                                                       | `후보자 상세`                                                                                                                               | `투표하기`                                                                                                                               |
| ----------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| <img src="https://raw.githubusercontent.com/syss220211/Union/refs/heads/develop/Union/images/home.PNG" width="143" height="300"> | <img src="https://raw.githubusercontent.com/syss220211/Union/refs/heads/develop/Union/images/candidateList.PNG" width="143" height="300"> | <img src="https://raw.githubusercontent.com/syss220211/Union/refs/heads/develop/Union/images/candidateDetail.PNG" width="143" height="300"> | <img src="https://raw.githubusercontent.com/syss220211/Union/refs/heads/develop/Union/images/voting.PNG " width="143" height="300"> |
