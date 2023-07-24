//
//  SecondView.swift
//  Example
//
//  Created by Tony on 2023/07/24.
//  
//

import SwiftUI
import ComposableArchitecture

public struct SecondView: View {
  @ObservedObject
  private var viewStore: ViewStoreOf<Second>
  private let store: StoreOf<Second>
  
  public init(store: StoreOf<Second>) {
    self.viewStore = ViewStoreOf<Second>(store)
    self.store = store
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      Text("Second View 입니다.")
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
