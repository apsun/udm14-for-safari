import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private func initMenu() {
        NSApp.mainMenu = NSMenu.make(
            title: "udm14 for Safari",
            children: [
                .submenu(
                    title: "udm14 for Safari",
                    children: [
                        .action(
                            title: "About udm14 for Safari",
                            action: #selector(NSApplication.orderFrontStandardAboutPanel(_:))
                        ),
                        .separator,
                        .action(
                            title: "Hide udm14 for Safari",
                            action: #selector(NSApplication.hide(_:)),
                            keyEquivalent: "h",
                            keyEquivalentModifierMask: [.command]
                        ),
                        .action(
                            title: "Hide Others",
                            action: #selector(NSApplication.hideOtherApplications(_:)),
                            keyEquivalent: "h",
                            keyEquivalentModifierMask: [.option, .command]
                        ),
                        .action(
                            title: "Show All",
                            action: #selector(NSApplication.unhideAllApplications(_:))
                        ),
                        .separator,
                        .action(
                            title: "Quit udm14 for Safari",
                            action: #selector(NSApplication.terminate(_:)),
                            keyEquivalent: "q",
                            keyEquivalentModifierMask: [.command]
                        )
                    ]
                )
            ]
        )
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        self.initMenu()

        let window = NSWindow(contentViewController: MainViewController())
        window.title = "udm14 for Safari"
        window.styleMask.remove(.resizable)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
