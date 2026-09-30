import Cocoa
import SwiftUI

final class AboutViewController: NSViewController {
    static func initWithStoryboard() -> AboutViewController {
        NSStoryboard(name: "Main", bundle: nil)
            .instantiateController(withIdentifier: "aboutVC") as! AboutViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let hostingView = NSHostingView(rootView: AboutSettingsView())
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingView)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 500),
            view.heightAnchor.constraint(equalToConstant: 350),
            hostingView.topAnchor.constraint(equalTo: view.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

private struct AboutSettingsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image("ic_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
            VStack(spacing: 4) {
                Text("Hidden Bar").font(.title2).fontWeight(.semibold)
                Text("Menu bar cleaner".localized).foregroundStyle(.secondary)
                Text("Version".localized + " " + (Bundle.main.releaseVersionNumber ?? "")
                     + " (" + (Bundle.main.buildVersionNumber ?? "") + ")")
                    .font(.callout).foregroundStyle(.secondary)
            }
            Divider().padding(.vertical, 4)
            Link("Source code".localized, destination: URL(string: "https://github.com/richarddemann/hiddenbarfix")!)
            Link("Report an issue".localized, destination: URL(string: "https://github.com/richarddemann/hiddenbarfix/issues")!)
            Link("Original project".localized, destination: URL(string: "https://github.com/dwarvesf/hidden")!)
            Text("MIT © Dwarves Foundation")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
