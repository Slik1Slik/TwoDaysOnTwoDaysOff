//
//  TabBarController.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 05.07.2021.
//

import SwiftUI

fileprivate struct UITabBarControllerWrapper: UIViewControllerRepresentable {
    var viewControllers: [UIViewController]
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<UITabBarControllerWrapper>) -> UITabBarController {
        let tabBar = UITabBarController()
        
        return tabBar
    }
    
    func updateUIViewController(_ uiViewController: UITabBarController, context: UIViewControllerRepresentableContext<UITabBarControllerWrapper>) {
        uiViewController.setViewControllers(self.viewControllers, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: UITabBarControllerWrapper
        
        init(_ controller: UITabBarControllerWrapper) {
            self.parent = controller
        }
    }
}

struct UITabBarWrapper: View {
    var controllers: [UIHostingController<TabBarElement>]
    
    init(_ elements: [TabBarElement]) {
        self.controllers = elements.enumerated().map {
            let hostingController = UIHostingController(rootView: $1)
            
            hostingController.tabBarItem = UITabBarItem(
                title: $1.tabBarElementItem.title,
                image: UIImage.init(systemName: $1.tabBarElementItem.systemImageName),
                tag: $0
            )
            
            return hostingController
        }
    }
    
    var body: some View {
        UITabBarControllerWrapper(viewControllers: self.controllers)
    }
}

struct UITabBarWrapper_Previews: PreviewProvider {
    static var previews: some View {
        UITabBarWrapper([
            TabBarElement(tabBarElementItem:
                            TabBarElementItem(title: "Test 1", systemImageName: "house.fill")) {
                Text("Test 1 Text")
            }
        ])
    }
}
