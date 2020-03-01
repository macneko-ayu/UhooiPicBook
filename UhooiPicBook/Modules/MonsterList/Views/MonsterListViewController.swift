//
//  MonsterListViewController.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit

/// @mockable
protocol MonsterListUserInterface: AnyObject {
    func showMonsters(monsters: [MonsterEntity])
}

final class MonsterListViewController: UIViewController {

    // MARK: Type Aliases

    // MARK: Stored Instance Properties

    var presenter: MonsterListEventHandler!

    private var monsters: [MonsterEntity] = []

    // MARK: Computed Instance Properties

    // MARK: IBOutlets

    @IBOutlet private weak var monstersCollectionView: UICollectionView! {
        willSet {
            newValue.register(R.nib.monsterCollectionViewCell)
        }
    }

    // MARK: View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter.viewDidLoad()
    }

    // MARK: IBActions

    // MARK: Other Private Methods

}

extension MonsterListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.monsters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.monstersCollectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.monsterCollectionViewCell, for: indexPath) else {
            fatalError("Fail to load MonsterCollectionViewCell.")
        }

        let monster = self.monsters[indexPath.row]
        cell.setup(icon: monster.icon, name: monster.name)

        return cell
    }

}

extension MonsterListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.monstersCollectionView.frame.width - 8.0 * 2, height: 84.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8.0
    }

}

extension MonsterListViewController: MonsterListUserInterface {

    func showMonsters(monsters: [MonsterEntity]) {
        self.monsters = monsters
        DispatchQueue.main.async {
            self.monstersCollectionView.reloadData()
        }
    }

}
