//
//  FirstView.swift
//  Example
//
//  Created by Tony on 2023/07/24.
//  
//

import SwiftUI
import ComposableArchitecture

public struct FirstView: View {
  @ObservedObject
  private var viewStore: ViewStoreOf<First>
  private let store: StoreOf<First>
  
  public init(store: StoreOf<First>) {
    self.viewStore = ViewStoreOf<First>(store, observe: { $0 })
    self.store = store
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      Text("First View 입니다.")
        .font(.title)
      
      Text("\(viewStore.value) 로 열렸습니다.")
        .font(.subheadline)
      
      Button("back") {
        viewStore.send(.tappedBackButton)
      }
      
      Button("push") {
        viewStore.send(.tappedPushButton)
      }
      
      Button("custom-sheet") {
        viewStore.send(.tappedCustomSheetButton)
      }
      
      Button("normal-sheet") {
        viewStore.send(.tappedNormalSheetButton)
      }
      
      Button("cover") {
        viewStore.send(.tappedCoverSheetButton)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.orange)
  }
}
