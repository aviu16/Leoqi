import UIKit

extension UIApplication {
    class func getFrontMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getFrontMostViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return getFrontMostViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return getFrontMostViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return getFrontMostViewController(base: presented)
        }
        
        return base
    }
}

