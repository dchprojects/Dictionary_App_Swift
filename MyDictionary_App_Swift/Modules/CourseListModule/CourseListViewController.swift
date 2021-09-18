//
//  CourseListViewController.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 11.08.2021.

import UIKit

final class CourseListViewController: MDBaseTitledNavigationBarViewController {
    
    fileprivate let presenter: CourseListPresenterInputProtocol
    
    fileprivate let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = .init()
        let collectionView: UICollectionView = .init(frame: .zero,
                                                     collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MDCourseListCell.self)
        return collectionView
    }()
    
    fileprivate static let settingsButtonSize: CGSize = .init(width: 40, height: 40)
    fileprivate static let settingsButtonLeftOffset: CGFloat = 8
    fileprivate static let settingsButtonBottomOffset: CGFloat = 8
    fileprivate let settingsButton: UIButton = {
        let button: UIButton = .init()
        button.setImage(MDAppStyling.Image.settings.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate static let addNewCourseButtonSize: CGSize = .init(width: 40, height: 40)
    fileprivate static let addNewCourseButtonRightOffset: CGFloat = 8
    fileprivate let addNewCourseButton: UIButton = {
        let button: UIButton = .init()
        button.setImage(MDAppStyling.Image.add.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate static let searchBarContainerViewHeight: CGFloat = 72
    fileprivate let searchBarContainerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate static let searchBarHeight: CGFloat = 56
    fileprivate static let searchBarTopOffset: CGFloat = 16
    fileprivate let searchBar: UISearchBar = {
        let searchBar: UISearchBar = .init()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    init(presenter: CourseListPresenterInputProtocol) {
        self.presenter = presenter
        super.init(title: KeysForTranslate.courses.localized,
                   navigationBarBackgroundImage: MDAppStyling.Image.background_navigation_bar_1.image)
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        addViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
        dropShadow()
    }
    
}

// MARK: - CourseListPresenterOutputProtocol
extension CourseListViewController: CourseListPresenterOutputProtocol {
    
    func appearanceHasBeenUpdated(_ newValue: AppearanceType) {
        configureAppearance(fromAppearanceType: newValue,
                            collectionView: collectionView)
    }
    
    func showError(_ error: Error) {
        UIAlertController.showAlertWithOkAction(title: KeysForTranslate.error.localized,
                                                message: error.localizedDescription,
                                                presenter: self)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: - Add Views
fileprivate extension CourseListViewController {
    
    func addViews() {
        addSettingsButton()
        addAddNewCourseButton()
        addCollectionView()
        addSearchBarContainerView()
        addSearchBar()
    }
    
    func addSettingsButton() {
        settingsButton.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
        view.addSubview(settingsButton)
    }
    
    func addAddNewCourseButton() {
        addNewCourseButton.addTarget(self, action: #selector(addNewCourseButtonAction), for: .touchUpInside)
        view.addSubview(addNewCourseButton)
    }
    
    func addCollectionView() {
        view.addSubview(collectionView)
    }
    
    func addSearchBarContainerView() {
        view.addSubview(searchBarContainerView)
    }
    
    func addSearchBar() {
        searchBar.delegate = presenter.searchBarDelegate
        searchBarContainerView.addSubview(searchBar)
    }
    
}

// MARK: - Add Constraints
fileprivate extension CourseListViewController {
    
    func addConstraints() {
        addSettingsButtonConstraints()
        addAddNewCourseButtonConstraints()
        addSearchBarContainerViewConstraints()
        addCollectionViewConstraints()
        addSearchBarConstraints()
    }
    
    func addSettingsButtonConstraints() {
        
        NSLayoutConstraint.addEqualConstraint(item: self.settingsButton,
                                              attribute: .bottom,
                                              toItem: self.titleLabel,
                                              attribute: .top,
                                              constant: -Self.settingsButtonBottomOffset)
        
        NSLayoutConstraint.addEqualLeftConstraint(item: self.settingsButton,
                                                  toItem: self.navigationBarView,
                                                  constant: Self.settingsButtonLeftOffset)
        
        NSLayoutConstraint.addEqualHeightConstraint(item: self.settingsButton,
                                                    constant: Self.settingsButtonSize.height)
        
        NSLayoutConstraint.addEqualWidthConstraint(item: self.settingsButton,
                                                   constant: Self.settingsButtonSize.width)
        
    }
    
    func addAddNewCourseButtonConstraints() {
        
        NSLayoutConstraint.addEqualCenterYConstraint(item: self.addNewCourseButton,
                                                     toItem: self.settingsButton,
                                                     constant: .zero)
        
        NSLayoutConstraint.addEqualRightConstraint(item: self.addNewCourseButton,
                                                   toItem: self.navigationBarView,
                                                   constant: -Self.addNewCourseButtonRightOffset)
        
        NSLayoutConstraint.addEqualHeightConstraint(item: self.addNewCourseButton,
                                                    constant: Self.addNewCourseButtonSize.height)
        
        NSLayoutConstraint.addEqualWidthConstraint(item: self.addNewCourseButton,
                                                   constant: Self.addNewCourseButtonSize.width)
        
    }
    
    func addSearchBarContainerViewConstraints() {
        
        NSLayoutConstraint.addEqualConstraint(item: self.searchBarContainerView,
                                              attribute: .top,
                                              toItem: navigationBarView,
                                              attribute: .bottom,
                                              constant: .zero)
        
        NSLayoutConstraint.addEqualLeftConstraint(item: self.searchBarContainerView,
                                                  toItem: self.view,
                                                  constant: .zero)
        
        NSLayoutConstraint.addEqualRightConstraint(item: self.searchBarContainerView,
                                                   toItem: self.view,
                                                   constant: .zero)
        
        NSLayoutConstraint.addEqualHeightConstraint(item: self.searchBarContainerView,
                                                    constant: Self.searchBarContainerViewHeight)
        
    }
    
    func addCollectionViewConstraints() {
        
        NSLayoutConstraint.addEqualConstraint(item: self.collectionView,
                                              attribute: .top,
                                              toItem: self.searchBarContainerView,
                                              attribute: .bottom,
                                              constant: .zero)
        
        NSLayoutConstraint.addEqualLeftConstraint(item: self.collectionView,
                                                  toItem: self.view,
                                                  constant: .zero)
        
        NSLayoutConstraint.addEqualRightConstraint(item: self.collectionView,
                                                   toItem: self.view,
                                                   constant: .zero)
        
        NSLayoutConstraint.addEqualBottomConstraint(item: self.collectionView,
                                                    toItem: self.view,
                                                    constant: .zero)
        
    }
    
    func addSearchBarConstraints() {
        
        NSLayoutConstraint.addEqualTopConstraint(item: self.searchBar,
                                                 toItem: self.searchBarContainerView,
                                                 constant: Self.searchBarTopOffset)
        
        NSLayoutConstraint.addEqualLeftConstraint(item: self.searchBar,
                                                  toItem: self.searchBarContainerView,
                                                  constant: .zero)
        
        NSLayoutConstraint.addEqualRightConstraint(item: self.searchBar,
                                                   toItem: self.searchBarContainerView,
                                                   constant: .zero)
        
        NSLayoutConstraint.addEqualBottomConstraint(item: self.searchBar,
                                                    toItem: self.searchBarContainerView,
                                                    constant: .zero)
        
    }
    
}

// MARK: - Configure UI
fileprivate extension CourseListViewController {
    
    func configureUI() {
        configureView()
        configureCollectionView()
    }
    
    func configureView() {
        self.configureViewBackgroundColor(fromAppearanceType: Appearance.current.appearanceType)
    }
    
    func configureCollectionView() {
        self.collectionView.delegate = self.presenter.collectionViewDelegate
        self.collectionView.dataSource = self.presenter.collectionViewDataSource
        self.configureCollectionViewBackgroundColor(fromAppearanceType: Appearance.current.appearanceType,
                                                    collectionView: collectionView)
    }
    
}

// MARK: - Drop Shadow
fileprivate extension CourseListViewController {
    
    func dropShadow() {
        
    }
    
}

// MARK: - Actions
fileprivate extension CourseListViewController {
    
    @objc func addNewCourseButtonAction() {
        presenter.addNewCourseButtonClicked()
    }
    
    @objc func settingsButtonAction() {
        presenter.settingsButtonClicked()
    }
    
}
