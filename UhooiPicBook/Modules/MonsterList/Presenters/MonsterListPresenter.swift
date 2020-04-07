//
//  MonsterListPresenter.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import Foundation

protocol MonsterListEventHandler: AnyObject {
    func viewDidLoad()
    func didSelectMonster(monster: MonsterEntity)
    func refreshMonsterList()
}

/// @mockable
protocol MonsterListInteractorOutput: AnyObject {
}

final class MonsterListPresenter {

    // MARK: Type Aliases

    // MARK: Stored Instance Properties

    private unowned let view: MonsterListUserInterface
    private let interactor: MonsterListInteractorInput
    private let router: MonsterListRouterInput

    // MARK: Computed Instance Properties

    // MARK: Initializers

    init(view: MonsterListUserInterface, interactor: MonsterListInteractorInput, router: MonsterListRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    // MARK: Other Private Methods

}

extension MonsterListPresenter: MonsterListEventHandler {

    func viewDidLoad() {
        self.view.startIndicator()
        self.interactor.fetchMonsters { result in
            switch result {
            case let .success(monsters):
                let monsterEntities = self.convertDTOsToEntities(dtos: monsters)
                self.view.showMonsters(monsters: monsterEntities)
                self.view.stopIndicator()
            case let .failure(error):
                // TODO: エラーハンドリング
                break
            }
        }
    }

    func didSelectMonster(monster: MonsterEntity) {
        self.router.showMonsterDetail(monster: monster)
    }

    func refreshMonsterList() {
        self.interactor.fetchMonsters { result in
            switch result {
            case let .success(monsters):
                let monsterEntities = self.convertDTOsToEntities(dtos: monsters)
                self.view.showMonsters(monsters: monsterEntities)
                self.view.endRefreshing()
            case let .failure(error):
                // TODO: エラーハンドリング
                break
            }
        }
    }

    private func convertDTOsToEntities(dtos: [MonsterDTO]) -> [MonsterEntity] {
        dtos.sorted { $0.order < $1.order } .map { convertDTOToEntity(dto: $0) }
    }

    private func convertDTOToEntity(dto: MonsterDTO) -> MonsterEntity {
        guard let iconUrl = URL(string: dto.iconUrlString) else {
            fatalError("") // TODO: エラーハンドリング
        }
        guard let dancingUrl = URL(string: dto.dancingUrlString) else {
            fatalError("") // TODO: エラーハンドリング
        }

        return MonsterEntity(name: dto.name,
                             description: dto.description.replacingOccurrences(of: "\\n", with: "\n"),
                             baseColorCode: dto.baseColorCode,
                             iconUrl: iconUrl,
                             dancingUrl: dancingUrl)
    }

}

extension MonsterListPresenter: MonsterListInteractorOutput {
}
