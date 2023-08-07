# TCARouteStack

#### TCARouteStack allows you to manage navigation and presentation states as a single stack in SwiftUI.

TCARouteStack allows you to manage navigation and presentation states as a single stack in SwiftUI.
💁🏻‍♂️ It supports iOS 16 and later.<br>
💁🏻‍♂️ Implemented purely using SwiftUI.<br>
💁🏻‍♂️ Based on NavigationStack implementation.<br>
💁🏻‍♂️ Supports various options for sheets (Presentation Detents, Presentation Drag Indicator).<br>

## Advantages

✅ With TCARouteStack, you can easily apply the Coordinator pattern in SwiftUI + TCA.<br>
✅ By using RouteStack and Deeplinks together, you can achieve a one-to-one relationship between scenes and deeplinks.<br>
✅ TCARouteStack allows you to easily present views using different methods such as push, sheet, cover, etc.

## Base

This project is built on top of [RouteStack](https://github.com/Monsteel/RouteStack).<br>
For more information, please refer to the documentation of the respective library.

## How to Use

You can achieve sophisticated routing with simple code.<br>
For detailed usage, please refer to the [example code](https://github.com/Monsteel/TCARouteStack/tree/main/Example).

### Basic Structure

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
    // Omitted
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

### Screen Transition with Deeplinks

You can use deeplinks to transition between screens without dependencies between them.

#### RouterView

```swift
public struct RouterView: View {
  public var body: some View {
    RouteStackStore(store, root: root) { store in
      // Omitted
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

      // Omitted
    }
    .forEachRoute {
      Screen()
    }
  }
}

```

## Let's Build Together

I'm open to contributions and improvements for anything that can be enhanced.<br>
Feel free to contribute through Pull Requests. 🙏

## License

TCARouteStack is available under the MIT license. See the [LICENSE](https://github.com/Monsteel/TCARouteStack/tree/main/LICENSE) file for more info.

## Auther

Tony | dev.e0eun@gmail.com
