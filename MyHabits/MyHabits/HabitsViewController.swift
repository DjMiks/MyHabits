//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Максим Ялынычев on 31.08.2022.
//

import UIKit

class HabitsViewController: UIViewController {
    
// MARK: - DATA
    
    private lazy var habitStore: HabitsStore = HabitsStore.shared
    
// MARK: - SUBVIEWS
    
    private lazy var habitsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = Styles.lightGrayColor
        collectionView.register(
            ProgressCollectionViewCell.self,
            forCellWithReuseIdentifier: ProgressCollectionViewCell.reuseID
        )
        collectionView.register(
            HabitCollectionViewCell.self,
            forCellWithReuseIdentifier: HabitCollectionViewCell.reuseID
        )
        collectionView.delegate = self
        collectionView.dataSource = self
          return collectionView
    }()
    
// MARK: - LIFECYCLE
    
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
    
// MARK: - PRIVATE METHODS
    
    private func setupView() {
        view.backgroundColor = .white
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addHabit))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupSubview() {
        view.addSubview(habitsCollectionView)
    }
    
    private func setupConstraints() {
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            habitsCollectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            habitsCollectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            habitsCollectionView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            habitsCollectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
        ])
    }
    
// MARK: - ACTIONS
    
    @objc func addHabit() {
        let addHabitController = AddHabitController()
        addHabitController.addHabitType = .create(createAction: { [weak self] in
            self?.habitsCollectionView.reloadData()
        })
        self.navigationController?.present(addHabitController, animated: true, completion: nil)
    }
}

// MARK: - EXTENSIONS

extension HabitsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            return
        }
        collectionView.deselectItem(at: indexPath, animated: true)
        let viewController = HabitDetailsViewController()
        viewController.habit = habitStore.habits[indexPath.item]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return habitStore.habits.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let progressCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.reuseID, for: indexPath) as! ProgressCollectionViewCell
            
            progressCell.show()
            return progressCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.reuseID, for: indexPath) as! HabitCollectionViewCell
            
            cell.setData(habit: habitStore.habits[indexPath.item])
            cell.habitTapCallback = { [weak self] in self?.habitsCollectionView.reloadData() }
            
            return cell
        }
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height: CGFloat;
        if indexPath.section == 0 {
            height = 60
        } else {
            height = 130
        }

        return .init(width: (UIScreen.main.bounds.width - 32), height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let top: CGFloat;
        let bottom: CGFloat;
        if section == 0 {
            top = 22
            bottom = 6
        } else {
            top = 18
            bottom = 12
        }
        return UIEdgeInsets(top: top, left: 16, bottom: bottom, right: 16)
    }
}
