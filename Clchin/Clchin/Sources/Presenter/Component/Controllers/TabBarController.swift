//
//  TabBarController.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import UIKit
import Then

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTabBarController()
        self.configureTabBar()
    }

    private func configureTabBarController() {
        self.tabBar.backgroundColor = .black
        
        self.viewControllers = Tab.allCases.map {
            let (title, image, selectedImage) = $0.itemResource
            
            return NavigationController(rootViewController: $0.viewController).then {
                $0.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
            }
        }
    }
    
    private func configureTabBar() {
        let apearance = UITabBarAppearance()
        
        apearance.configureWithTransparentBackground()
        self.tabBar.standardAppearance = apearance
        self.tabBar.scrollEdgeAppearance = apearance
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .systemGray5
    }
}


extension TabBarController {
    typealias TabItemResource = (title: String, image: UIImage?, selectedImage: UIImage?)
    
    enum Tab: CaseIterable {
        case lounge
        case search
        case crew
        case myPage
        
        var viewController: UIViewController {
            switch self {
            case .lounge:
                return ViewController()
            case .search:
                return ClimbingGymSearchViewController(viewModel: ClimbingGymSearchViewModel(searchClimbingGymUseCase: DefaultSearchClimbingGymUseCase(climbingRepository: DefaultClimbingGymRepository())))
            case .crew:
                return ViewController()
            case .myPage:
                return ViewController()
            }
        }
        
        var itemResource: TabItemResource {
            switch self {
            case .lounge:
                return (title: "라운지", image: UIImage.loungeTabIcon, selectedImage: UIImage.loungeFillTabIcon)
            case .search:
                return (title: "암장 검색", image: UIImage.searchIcon, selectedImage: UIImage.searchIcon)
            case .crew:
                return (title: "크루 모집", image: UIImage.crewTabIcon, selectedImage: UIImage.crewTabIcon)
            case .myPage:
                return (title: "마이", image: UIImage.myPageTabIcon, selectedImage: UIImage.myPageFillTabIcon)
            }
        }
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }
}
