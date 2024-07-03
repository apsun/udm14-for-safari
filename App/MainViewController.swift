import UIKit

class MainViewController: UINavigationController {
    override func viewDidLoad() {
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance
        self.setViewControllers([MainViewControllerImpl()], animated: false)
    }
}

fileprivate class MainViewControllerImpl
    : UIViewController
    , PreferenceDelegate
{
    private var preferenceViewController: PreferenceViewController!

    override func viewDidLoad() {
        self.title = "udm14 for Safari"

        self.preferenceViewController = PreferenceViewController(root: PreferenceRoot(sections: [
            PreferenceSection(
                header: "Actions",
                footer: """
                    Enable the extension in Safari settings, grant permissions for google.com, \
                    and you're all set!

                    Credit to udm14.com for the method and logo.
                    """,
                preferences: [
                    Preference(
                        id: "open_settings",
                        type: .button(label: "Open Safari extension settings")
                    ),
                ]
            ),
        ]))
        self.addChild(self.preferenceViewController)
        self.preferenceViewController.view
            .autoLayoutInView(self.view)
            .fill(self.view)
            .activate()
        self.preferenceViewController.didMove(toParent: self)
        self.preferenceViewController.delegate = self
    }


    func preferenceView(didClickButton id: String) {
        switch id {
        case "open_settings":
            UIApplication.shared.open(URL(string: "App-Prefs:SAFARI&path=WEB_EXTENSIONS")!)
        default:
            abort()
        }
    }
}
