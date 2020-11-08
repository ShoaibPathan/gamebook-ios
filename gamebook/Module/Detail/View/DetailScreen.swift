//
//  DetailScreen.swift
//  fundamental-sub-one
//
//  Created by Abdul Chathil on 7/2/20.
//  Copyright © 2020 Abdul Chathil. All rights reserved.
//

import SwiftUI
import Cleanse
import SDWebImageSwiftUI

struct DetailScreen: View {
    @ObservedObject var presenter: DetailPresenter

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    GamePoster(url: URL(string: presenter.game.backgroundImage)!)
                        .frame(height: 316)
                        .padding(.bottom)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(presenter.game.publishers, id: \.self) {
                                Chip(text: $0)
                            }
                        }
                    }
                }.padding(.bottom)
                
                Text(presenter.game.name).font(.largeTitle).fontWeight(.bold).padding(.leading)
                
                HStack {
                    Image("meta").resizable().frame(width: 26, height: 26, alignment: .center)
                    Text(String(presenter.game.metacritic)).font(.body).bold()
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(Color("primary"))
                    Text(String(presenter.game.gameRating)).font(.body).bold()
                }.padding(.leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Chip(text: presenter.game.released).lineLimit(1).padding(.leading).frame(minWidth: 126, alignment: .leading)
                        Chip(text: presenter.game.esrbRating)
                        ForEach(presenter.game.genres, id: \.self) {
                            Chip(text: $0)
                        }
                    }
                }
                
                Text(presenter.game.descriptionRaw).font(.body).padding()
                
            }
        }.onAppear {
            self.presenter.getGame()
        }.edgesIgnoringSafeArea(.all)
        
    }
    
}

struct GamePoster: View {
    @State var url: URL
    var body: some View {
                GeometryReader {geo in
                    WebImage(url: url)
                        .resizable()
                        .placeholder {
                                Rectangle().foregroundColor(.gray)
                            }
                            .indicator(.activity)
                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                        .scaledToFill()
                        .frame(width: geo.size.width, height: 316, alignment: .center)
                }
    }
}

struct DetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailScreen(presenter: DetailPresenter(detailUseCase: DetailInteractorPreview()))
    }
}