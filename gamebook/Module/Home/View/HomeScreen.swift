//
//  HomeScreen.swift
//  fundamental-sub-one
//
//  Created by Abdul Chathil on 7/2/20.
//  Copyright © 2020 Abdul Chathil. All rights reserved.
//

import SwiftUI
import Cleanse

struct HomeScreen: View {
    @ObservedObject var presenter: HomePresenter
    @EnvironmentObject private var user: User
    @State private var navBarHidden: Bool = true
    var body: some View {
        List {
            self.presenter.aboutLinkBuilder {
                AccountSnippet().padding(EdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 0))
            }
            self.presenter.favoriteLinkBuilder {
                FavoriteRow()
            }
            FindRow(query: self.$presenter.query)
            if self.presenter.loadingState {
                ForEach(0...5, id: \.self) { _ in
                    GameRowLoading()
                }
            } else {
                ForEach(self.presenter.games, id: \.id) { game in
                    self.presenter.detailLinkBuilder(for: game) {
                        GameRow(game: game, isLiked: presenter.likedIds.contains(game)) {
                            presenter.likeDislike(game: game)
                        }
                    }
                }
            }
        }
        .onAppear {
            self.presenter.getGames()
            self.presenter.initialLiked()
        }
        .environment(\.defaultMinListRowHeight, 132).listSeparatorStyleNone()
        .navigationBarTitle("")
        .navigationBarHidden(self.navBarHidden)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.navBarHidden = true
        }.gesture(DragGesture().onChanged {_ in
            UIApplication.shared
                .sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.navBarHidden = false
        }
    }
}
