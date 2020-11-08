//
//  DetailPresenter.swift
//  gamebook
//
//  Created by Abdul Chathil on 11/3/20.
//  Copyright © 2020 Abdul Chathil. All rights reserved.
//

import SwiftUI
import Combine
import Cleanse

class DetailPresenter: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let detailUseCase: DetailUseCase
    
    @Published var game: GameModel
    @Published var errorMessage: String = ""
    @Published var loadingState: Bool = false
    
    init(detailUseCase: DetailUseCase) {
        self.detailUseCase = detailUseCase
        self.game = detailUseCase.getGame()
    }
    
    func getGame() {
        detailUseCase.getGame().receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure: self.errorMessage = String(describing: completion)
                case .finished: self.loadingState = false
                }
            }, receiveValue: {
                self.game = $0 ?? self.game
            }).store(in: &cancellables)
    }
}

extension DetailPresenter {
    struct Module: Cleanse.Module {
        static func configure(binder: Binder<Unscoped>) {
            binder.include(module: DetailInteractor.Module.self)
            binder.bind(DetailPresenter.self).to(factory: DetailPresenter.init)
        }
    }
}