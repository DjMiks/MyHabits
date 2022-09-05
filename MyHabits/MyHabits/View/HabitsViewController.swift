//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Максим Ялынычев on 31.08.2022.
//

import UIKit

class HabitsViewController: UIViewController {

    // MARK: DATA
    
    private lazy var habitStore: HabitsStore = HabitsStore.shared
    
    
    // MARK: SUBViEW
    
    private lazy var habitsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Styles.leghtGrayColor
        collectionView.register(
            ProgressCollectionViewCell.self,
           forCellWithReuseIdentifier: ProgressCollectionViewCell.reuseID)
        collectionView.register(HabitCollectionViewCell.self,
           forCellWithReuseIdentifier: HabitCollectionViewCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
               return collectionView
    }()
    
    
    // MARK: CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSubview()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        habitsCollectionView.reloadData()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: Prifate Method
    
    private func setupView() {
        view.backgroundColor = .white
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabit))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupSubview() {
        view.addSubview(habitsCollectionView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            habitsCollectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            habitsCollectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            habitsCollectionView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            habitsCollectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
         ])
    }
    
    // MARK: - Actions
    
    @objc func addHabit() {
        let addHabitsController = AddH()
        addHabitsController.addHabitType = .create(createAction: { [weak self] in
        self?.habitsCollectionView.reloadData()
       })
    self.navigationController?.present(addHabitsController, animated: true, completion: nil)
  }

}
