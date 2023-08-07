# TCARouteStack

#### SwiftUI + TCA 에서 navigation 과 presentation 상태를 하나의 Stack으로 관리할 수 있습니다.

[There is also an explanation in English.](https://github.com/Monsteel/TCARouteStack/tree/main/README_EN.md)

💁🏻‍♂️ iOS16+ 를 지원합니다.<br>
💁🏻‍♂️ 순수한 SwiftUI 를 사용하여 구현되었습니다.<br>
💁🏻‍♂️ NavigationStack을 기반으로 하여 구현되었습니다.<br>
💁🏻‍♂️ sheet의 다양한 옵션(Presentation Detents, Presentation Drag Indicator)을 지원합니다.<br>

## 장점

✅ TCARouteStack을 사용하면, SwiftUI + TCA 환경에서 **Coordinator 개념을 쉽게 적용시킬 수 있습니다.**<br>
✅ TCARouteStack과 Deeplink를 함께 사용하여, **화면(Scene) : Deeplink = 1:1 을 구현할 수 있습니다.**<br>
✅ TCARouteStack을 사용하면, 상황에 따라 노출 방식(push, sheet, cover..)을 선택하여 **쉽게 보여줄 수 있습니다.**<br>

## 기반

이 프로젝트는 [RouteStack](https://github.com/Monsteel/RouteStack)을 기반으로 구현되었습니다.<br>
보다 자세한 내용은 해당 라이브러리의 문서를 참고해 주세요

## 사용방법

간단한 코드로, 멋진 Routing을 구현할 수 있습니다.<br>
자세한 사용방법은 [예제코드](https://github.com/Monsteel/TCARouteStack/tree/main/Example)를 참고해주세요.

### 기본 구조

#### RouterView

```swift
public struct RouterView: View {
  @ObservedObject
  private var viewStore: ViewStoreOf<Router>
  private let store: StoreOf<Router>

  public init(store: StoreOf<Router>) {
    self.viewStore = ViewStoreOf<Router>(store)
    self.store = store
  }

  private func root() -> some View {
    // 생략
  }

  public var body: some View {
    RouteStackStore(store, root: root) { store in
      SwitchStore(store) { state in
        switch state {
        case .first:
          CaseLet(/Screen.State.first, action: Screen.Action.first, then: FirstView.init)

        case .second:
          CaseLet(/Screen.State.second, action: Screen.Action.second, then: SecondView.init)

        case .third:
          CaseLet(/Screen.State.third, action: Screen.Action.third, then: ThirdView.init)
        }
      }
    }
  }
}
```

#### RouterCore

```swift
public struct Router: ReducerProtocol {
  public struct State: Equatable, RouterState {
    public var paths: [RoutePath<Screen.State>]
  }

  public enum Action: Equatable, RouterAction {
    case updatePaths([RoutePath<Screen.State>])
    case pathAction(RoutePath<Screen.State>.ID, action: Screen.Action)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .updatePaths:
        return .none
      case .pathAction:
        return .none
      }
    }
    .forEachRoute {
      Screen()
    }
    Scope(state: \.root, action: /Action.root) { Root() }
  }
}

public struct Screen: ReducerProtocol {
  public enum State: Equatable {
    case first(First.State)
    case second(Second.State)
    case third(Third.State)
  }

  public enum Action: Equatable {
    case first(First.Action)
    case second(Second.Action)
    case third(Third.Action)
  }

  public var body: some ReducerProtocol<State, Action> {
    Scope(state: /State.first, action: /Action.first) {
      First()
    }
    Scope(state: /State.second, action: /Action.second) {
      Second()
    }
    Scope(state: /State.third, action: /Action.third) {
      Third()
    }
  }
}

```

### deeplink를 사용한 화면 전환 방법

deeplink를 활용해 화면 간 의존성 없이 화면을 전환할 수 있습니다.

#### RouterView

```swift
public struct RouterView: View {
  public var body: some View {
    RouteStackStore(store, root: root) { store in
      // 생략
    }.onOpenURL { url in
      viewStore.send(.openURL(url))
    }
  }
}
```

#### RouterCore

```swift
public struct Router: ReducerProtocol {
  public struct State: Equatable, RouterState {
    public var paths: [RoutePath<Screen.State>]
    // 생략
  }

  public enum Action: Equatable, RouterAction {
    case openURL(URL)
    // 생략
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case let .openURL(url):
        switch url.host {
        case "back":
          state.paths.removeLast()
        case "backToRoot":
          state.paths.removeAll()
        case "firstView":
          state.paths.append(RoutePath(data: Screen.State.first(.init()), style: .cover))
        case "secondView":
          state.paths.append(RoutePath(data: Screen.State.second(.init()), style: .push))
        case "thirdView":
          state.paths.append(RoutePath(data: Screen.State.third(.init()), style: .sheet([.medium, .large], .visible)))
        default: break
        }
        return .none
      }

      // 생략
    }
    .forEachRoute {
      Screen()
    }
  }
}

```

## Swift Package Manager(SPM) 을 통해 사용할 수 있어요

```swift
dependencies: [
  .package(url: "https://github.com/Monsteel/TCARouteStack.git", .upToNextMajor(from: "0.0.1"))
]
```

## 함께 만들어 나가요

개선의 여지가 있는 모든 것들에 대해 열려있습니다.<br>
PullRequest를 통해 기여해주세요. 🙏

## License

TCARouteStack 는 MIT 라이선스로 이용할 수 있습니다. 자세한 내용은 [라이선스](https://github.com/Monsteel/TCARouteStack/tree/main/LICENSE) 파일을 참조해 주세요.<br>
TCARouteStack is available under the MIT license. See the [LICENSE](https://github.com/Monsteel/TCARouteStack/tree/main/LICENSE) file for more info.

## Auther

이영은(Tony) | dev.e0eun@gmail.com

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FMonsteel%2FTCARouteStack&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
