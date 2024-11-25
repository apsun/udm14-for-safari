import AppKit
import SafariServices

class MainViewController: NSViewController {
    @objc
    private func showSafariSettings() {
        SFSafariApplication.showPreferencesForExtension(
            withIdentifier: "com.crossbowffs.udm14-for-safari.Extension"
        ) { error in
            DispatchQueue.main.async {
                NSApp.terminate(self)
            }
        }
    }

    override func viewDidLoad() {
        let view = self.view

        let label = NSTextField(string: """
            Enable the extension in Safari settings, grant permissions for google.com, \
            and you're all set!
            """
        )
        label.isBezeled = false
        label.drawsBackground = false
        label.isEditable = false
        label.isSelectable = false
        label.autoLayoutInView(view)
            .left(view.leadingAnchor, constant: 8)
            .right(view.trailingAnchor, constant: -8)
            .top(view.topAnchor, constant: 8)
            .activate()

        let button = NSButton(
            title: "Open Safari settings",
            target: self,
            action: #selector(self.showSafariSettings)
        )
        button.autoLayoutInView(view)
            .centerX(view.centerXAnchor)
            .below(label)
            .bottom(view.bottomAnchor, constant: -8)
            .activate()
    }
}
