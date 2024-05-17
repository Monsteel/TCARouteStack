//
//  ForEachReducer.swift
//
//
//  Created by Tony on 2023/07/24.
//

import ComposableArchitecture
import RouteStack
import Foundation

extension Reducer {
  public func forEachRoute<ElementState, ElementAction, Element: Reducer>(
    @ReducerBuilder<ElementState, ElementAction> element: () -> Element,
    file: StaticString = #file,
    fileID: StaticString = #fileID,
    line: UInt = #line
  ) -> some Reducer<Self.State, Self.Action>
  where
  ElementState == Element.State, ElementAction == Element.Action,
  Self.State: RouterState, Self.Action: RouterAction,
  Self.Action.ScreenAction == ElementAction,
  Self.Action.Screen == ElementState, Self.State.Screen == ElementState
  {
    CombineReducers {
      _ForEachRoutePathIDReducer(
        parent: self,
        toElementsState: \.paths,
        toElementAction: /Self.Action.pathAction,
        element: element(),
        file: file,
        fileID: fileID,
        line: line
      )
      
      _UpdatePathsOnInteraction(
        reducer: self,
        updatePaths: /Action.updatePaths,
        toLocalState: \.paths
      )
    }
  }
}

struct _UpdatePathsOnInteraction<Parent: Reducer, Routes>: Reducer {
  typealias State = Parent.State
  typealias Action = Parent.Action
  
  let reducer: Parent
  let updatePaths: AnyCasePath<Action, Routes>
  let toLocalState: WritableKeyPath<State, Routes>
  
  func reduce(into state: inout Parent.State, action: Parent.Action) -> Effect<Action> {
    if let routes = updatePaths.extract(from: action) {
      state[keyPath: toLocalState] = routes
    }
    return .none
  }
}


struct _ForEachRoutePathIDReducer<
  Parent: Reducer,
  Element: Reducer
>: Reducer
where
Parent.State: RouterState,
Parent.Action: RouterAction,
Element.State: Equatable,
Element.Action: Equatable,
Element.State == Parent.State.Screen
{
  typealias ID = RoutePath<Element.State>.ID
  
  let parent: Parent
  let toElementsState: WritableKeyPath<Parent.State, [RoutePath<Element.State>]>
  let toElementAction: AnyCasePath<Parent.Action, (ID, Element.Action)>
  let element: Element
  let file: StaticString
  let fileID: StaticString
  let line: UInt
  
  init(
    parent: Parent,
    toElementsState: WritableKeyPath<Parent.State, [RoutePath<Element.State>]>,
    toElementAction: AnyCasePath<Parent.Action, (ID, Element.Action)>,
    element: Element,
    file: StaticString,
    fileID: StaticString,
    line: UInt
  ) {
    self.parent = parent
    self.toElementsState = toElementsState
    self.toElementAction = toElementAction
    self.element = element
    self.file = file
    self.fileID = fileID
    self.line = line
  }
  
  public func reduce(
    into state: inout Parent.State, action: Parent.Action
  ) -> Effect<Parent.Action> {
    self.reduceForEach(into: &state, action: action)
      .merge(with: self.parent.reduce(into: &state, action: action))
  }
  
  func reduceForEach(
    into state: inout Parent.State, action: Parent.Action
  ) -> Effect<Parent.Action> {
    guard let (id, elementAction) = self.toElementAction.extract(from: action) else { return .none }
    let array = state[keyPath: self.toElementsState]
    guard let index = array.firstIndex(where: { $0.id == id }) else { return .none }
    
    if array[safe: index] == nil {
      runtimeWarn(
        """
        A "forEachRoute" at "\(self.fileID):\(self.line)" received an action for a screen at \
        index \(index) but the screens array only contains \(array.count) elements.
        
          Action:
            \(action)
        
        This may be because a parent reducer (e.g. coordinator reducer) removed the screen at \
        this index before the action was sent.
        """,
        file: self.file,
        line: self.line
      )
      return .none
    }
    return self.element
      .reduce(into: &state[keyPath: self.toElementsState][index].data, action: elementAction)
      .map { self.toElementAction.embed((id, $0)) }
  }
}

func runtimeWarn(
  _ message: @autoclosure () -> String,
  file: StaticString? = nil,
  line: UInt? = nil
) {
#if DEBUG
  let message = message()
  if _XCTIsTesting {
    if let file = file, let line = line {
      XCTFail(message, file: file, line: line)
    } else {
      XCTFail(message)
    }
  } else {
    let formatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd HH:MM:SS.sssZ"
      return formatter
    }()
    fputs("\(formatter.string(from: Date())) [TCARouteStack] \(message)\n", stderr)
  }
#endif
}
