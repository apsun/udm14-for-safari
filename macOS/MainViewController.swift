import AppKit
import SafariServices

class MainViewController: NSViewController {
    @objc
    private func showSafariSettings() {
        SFSafariApplication.showPreferencesForExtension(
            withIdentifier: "com.crossbowffs.udm14-for-safari.Extension"
        ) { error in
            DispatchQueue.main.async {
                // NSApp.terminate(self)
            }
        }
    }

    override func viewDidLoad() {
        let view = self.view

        let label = NSTextField(wrappingLabelWithString: """
            Enable the extension in Safari settings, grant permissions for google.com, \
            and you're all set!
            """
        )
        label.autoLayoutInView(view)
            .width(352)
            .left(view.leadingAnchor, constant: 16)
            .right(view.trailingAnchor, constant: -16)
            .top(view.topAnchor, constant: 16)
            .activate()

        let button = NSButton(
            title: "Open Safari settings",
            target: self,
            action: #selector(self.showSafariSettings)
        )
        button.autoLayoutInView(view)
            .centerX(view.centerXAnchor)
            .top(label.bottomAnchor, constant: 16)
            .bottom(view.bottomAnchor, constant: -16)
            .activate()
    }
}
