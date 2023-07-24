//
//  ContentView.swift
//  Example
//
//  Created by Tony on 2023/07/21.
//

import SwiftUI
import RouteStack

struct ContentView: View {
  @State var routePaths: RoutePaths<Path> = .init()
  
  @ViewBuilder
  func root() -> some View {
    
  }
  
  var body: some View {
    RouteStack($routePaths, root: root) { id, path in
      switch path {
      case let .first(value):
        VStack(alignment: .leading) {
          Text("First View 입니다.")
            .font(.title)
          
          Text("\(value) 로 열렸습니다.")
            .font(.subheadline)
          
          Button("back") {
            // Deeplink를 통해 routePaths에 직접 접근하지 않고 이동할 수 있습니다.
            UIApplication.shared.open(URL(string: "routeStackExample://back")!)
          }
          
          Button("push") {
            routePaths.moveTo(.init(data: Path.second("push"), style: .push))
          }
          
          Button("custom-sheet") {
            routePaths.moveTo(.init(data: Path.second("custom-sheet"), style: .sheet([.medium, .large], .visible)))
          }
          
          Button("normal-sheet") {
            routePaths.moveTo(.init(data: Path.second("normal-sheet"), style: .sheet()))
          }
          
          Button("cover") {
            routePaths.moveTo(.init(data: Path.second("cover"), style: .cover))
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.orange)
      case let .second(value):
        VStack(alignment: .leading) {
          Text("Second View 입니다.")
            .font(.title)
          
          Text("\(value) 로 열렸습니다.")
            .font(.subheadline)
          
          Button("back") {
            // Deeplink를 통해 routePaths에 직접 접근하지 않고 이동할 수 있습니다.
            UIApplication.shared.open(URL(string: "routeStackExample://back")!)
          }
          
          Button("push") {
            routePaths.moveTo(.init(data: Path.third("push"), style: .push))
          }
          
          Button("custom-sheet") {
            routePaths.moveTo(.init(data: Path.third("custom-sheet"), style: .sheet([.medium, .large], .visible)))
          }
          
          Button("normal-sheet") {
            routePaths.moveTo(.init(data: Path.third("normal-sheet"), style: .sheet()))
          }
          
          Button("cover") {
            routePaths.moveTo(.init(data: Path.third("cover"), style: .cover))
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
      case let .third(value):
        VStack(alignment: .leading) {
          Text("Third View 입니다.")
            .font(.title)
          
          Text("\(value) 로 열렸습니다.")
            .font(.subheadline)
          
          Button("back") {
            // Deeplink를 통해 routePaths에 직접 접근하지 않고 이동할 수 있습니다.
            UIApplication.shared.open(URL(string: "routeStackExample://back")!)
          }
          
          Button("back To root") {
            // Deeplink를 통해 routePaths에 직접 접근하지 않고 이동할 수 있습니다.
            UIApplication.shared.open(URL(string: "routeStackExample://backToRoot")!)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
      }
    }
    .onOpenURL { url in
      switch url.host {
      case "back":
        routePaths.back()
      case "backToRoot":
        routePaths.backToRoot()
      default: break
      }
    }
  }
}

enum Path: Equatable {
  case first(String)
  case second(String)
  case third(String)
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}