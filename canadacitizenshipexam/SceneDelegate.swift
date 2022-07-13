//
//  SceneDelegate.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2022-04-30.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // Casts and unwraps the window scene.
    guard let windowScene = (scene as? UIWindowScene) else { return }

    self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    self.window?.windowScene = windowScene
    self.window?.rootViewController = self.createPrimaryTabBarController()
    self.window?.makeKeyAndVisible()
    self.configureNavigationBar()
  }

  func createLoginVC() -> UINavigationController {
    let navController         = UINavigationController(rootViewController: RegisterVC(nibName: nil, bundle: nil))
    navController.title       = "Login"
    navController.tabBarItem  = UITabBarItem(
      title: "Login", image: UIImage(systemName: SFSymbols.userProfile), tag: 0
    )
    return navController
  }

  func createHomeNC() -> UINavigationController {
    let navController         = UINavigationController(rootViewController: HomeVC())
    navController.title       = "Discover Canada"
    navController.tabBarItem  = UITabBarItem(
      title: "Home", image: UIImage(systemName: SFSymbols.home), tag: 0
    )
    return navController
  }

  func createTestsNC() -> UINavigationController {
    let navController         = UINavigationController(rootViewController: TestsVC())
    navController.title       = "Practice Tests"
    navController.tabBarItem  = UITabBarItem(
      title: "Tests", image: UIImage(systemName: SFSymbols.tests), tag: 1
    )
    return navController
  }

  func createBookNC() -> UINavigationController {
    let navController         = UINavigationController(rootViewController: BookVC())
    navController.title       = "Study Book"
    navController.tabBarItem  = UITabBarItem(title: "Book", image: UIImage(systemName: SFSymbols.book), tag: 2)
    return navController
  }

  func createProgressNC() -> UINavigationController {
    // Old way: programmatic UI
    // let navController        = UINavigationController(rootViewController: ProgressVC())

    // New way: storyboard
    let storyboard = UIStoryboard(name: "ProgressVC", bundle: nil)
    let navController        = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "ProgressVC"))

    navController.title      = "Study Progress"
    navController.tabBarItem = UITabBarItem(title: "Progress", image: UIImage(systemName: SFSymbols.progress), tag: 3)
    return navController
  }

  func createSettingsNC() -> UINavigationController {
    let navController        = UINavigationController(rootViewController: SettingsVC())
    navController.title      = "Settings"
    navController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: SFSymbols.progress), tag: 4)
    return navController
  }

  func createPrimaryTabBarController() -> UITabBarController {
    let tabBarController              = UITabBarController()
    tabBarController.tabBar.tintColor = .systemRed
    tabBarController.viewControllers  = [
      createHomeNC(),
      createTestsNC(),
      createBookNC(),
      createProgressNC(),
      createSettingsNC()
    ]
    return tabBarController
  }

  // Global configurations for all navigation bar.
  func configureNavigationBar() -> Void {
    UINavigationBar.appearance().tintColor = .systemRed
  }

  // ===========================================================================
  // DO NOT CHANGE ANYTHING BELOW THIS LINE
  // ===========================================================================

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.

    // Save changes in the application's managed object context when the application transitions to the background.
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }

}
