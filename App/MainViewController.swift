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
    private static let prefSettings = "open_settings"
    private static let prefGitHub = "open_github"
    private static let prefUdm14 = "open_udm14"

    private var preferenceViewController: PreferenceViewController!

    override func viewDidLoad() {
        self.title = "udm14 for Safari"

        self.preferenceViewController = PreferenceViewController(root: PreferenceRoot(sections: [
            PreferenceSection(
                header: "Actions",
                footer: """
                    Enable the extension in Safari settings, grant permissions for google.com, \
                    and you're all set!
                    """,
                preferences: [
                    Preference(
                        id: Self.prefSettings,
                        type: .button(label: "Open Safari extension settings")
                    ),
                ]
            ),
            PreferenceSection(
                header: "About",
                footer: "Credit to udm14.com for the method and logo.",
                preferences: [
                    Preference(
                        id: Self.prefGitHub,
                        type: .button(label: "Visit project on GitHub")
                    ),
                    Preference(
                        id: Self.prefUdm14,
                        type: .button(label: "More info on udm14.com")
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
        case Self.prefSettings:
            UIApplication.shared.open(URL(string: "App-Prefs:SAFARI&path=WEB_EXTENSIONS")!)
        case Self.prefGitHub:
            UIApplication.shared.open(URL(string: "https://github.com/apsun/udm14-for-safari")!)
        case Self.prefUdm14:
            UIApplication.shared.open(URL(string: "https://udm14.com/")!)
        default:
            abort()
        }
    }
}
