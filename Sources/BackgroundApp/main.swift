import AppKit

class AppDelegate: NSObject, NSApplicationDelegate
{
	var window: NSWindow!
	private var popupTimer: Timer?
	private var nextTimeLabel: NSTextField!

	func applicationDidFinishLaunching(_ notification: Notification)
	{
		NSApp.setActivationPolicy(.accessory)

		   window = NSWindow(
			   contentRect: NSRect(x: 0, y: 0, width: 600, height: 300),
			   styleMask: [.titled, .closable, .fullSizeContentView],
			   backing: .buffered,
			   defer: false
		   )
		   window.isReleasedWhenClosed = false

		   window.center()

		   // Show initially
		   showPopup()
		   window.titleVisibility = .hidden
		   window.titlebarAppearsTransparent = true
		   window.backgroundColor = NSColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1.0)

		   // Create the content view
		   let contentView = NSView(frame: NSRect(x: 0, y: 0, width: 600, height: 300))

		   // Create the label
		   let label = NSTextField(labelWithString: "Please stand by for a scheduled horse moment.\n\nYou will now contemplate and reflect. This is a time of seriousness.\n\nYou currently have scheduled horse moments turned on. You cannot change this in settings.")
		   label.font = NSFont.systemFont(ofSize: 18)
		   label.textColor = .black
		   label.alignment = .left
		   label.cell?.wraps = true
		   label.cell?.isScrollable = false
		   label.maximumNumberOfLines = 0
		   // Set a preferred max width so it wraps before expanding the window too much
		   label.preferredMaxLayoutWidth = 300

		   // Create the image view
		   var image: NSImage? = nil
		   if let imageUrl = Bundle.module.url(forResource: "horse", withExtension: "png") {
			   image = NSImage(contentsOf: imageUrl)
		   }
		   let imageView = NSImageView(image: image ?? NSImage())
		   imageView.imageScaling = .scaleProportionallyUpOrDown
		   imageView.translatesAutoresizingMaskIntoConstraints = false
		   imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
		   imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true

		   // Create a horizontal stack view
		   let stackView = NSStackView()
		   stackView.orientation = .horizontal
		   stackView.spacing = 12
		   stackView.alignment = .centerY
		   stackView.translatesAutoresizingMaskIntoConstraints = false
		   stackView.addArrangedSubview(label)
		   stackView.addArrangedSubview(imageView)

		   contentView.addSubview(stackView)
		   window.contentView = contentView

		   // Custom Title Bar View
		   let titleImage = NSImageView(image: image ?? NSImage())
		   titleImage.imageScaling = .scaleProportionallyUpOrDown
		   titleImage.translatesAutoresizingMaskIntoConstraints = false
		   titleImage.heightAnchor.constraint(equalToConstant: 16).isActive = true
		   titleImage.widthAnchor.constraint(equalToConstant: 16).isActive = true

		   let titleLabel = NSTextField(labelWithString: "Scheduled Horse Moment")
		   titleLabel.font = NSFont.boldSystemFont(ofSize: 13)
		   titleLabel.textColor = .black

		   let titleStack = NSStackView(views: [titleImage, titleLabel])
		   titleStack.orientation = .horizontal
		   titleStack.spacing = 6
		   titleStack.translatesAutoresizingMaskIntoConstraints = false

		   contentView.addSubview(titleStack)

		   nextTimeLabel = NSTextField(labelWithString: "Next scheduled horse moment: --:-- --")
		   nextTimeLabel.font = NSFont.systemFont(ofSize: 12)
		   nextTimeLabel.textColor = .black
		   nextTimeLabel.alignment = .left
		   nextTimeLabel.translatesAutoresizingMaskIntoConstraints = false
		   contentView.addSubview(nextTimeLabel)

		   // Center the stack view in the content view
		   NSLayoutConstraint.activate([
			   stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			   stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			   titleStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			   titleStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			   nextTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			   nextTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
		   ])

		   // Schedule the first popup and keep rescheduling after each run
		   scheduleNextPopup()
	}

	@objc func showPopup()
	{
		if !window.isVisible {
			window.center()
			window.makeKeyAndOrderFront(nil)
			NSApp.activate(ignoringOtherApps: true)
		}
	}

	private func scheduleNextPopup()
	{
		let minInterval: TimeInterval = 30 * 60
		let maxInterval: TimeInterval = 120 * 60
		let interval = Double.random(in: minInterval...maxInterval)
		let nextDate = Date().addingTimeInterval(interval)
		updateNextPopupLabel(nextDate)

		popupTimer?.invalidate()
		popupTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
			self?.showPopup()
			self?.scheduleNextPopup()
		}
	}

	private func updateNextPopupLabel(_ date: Date)
	{
		let formatter = DateFormatter()
		formatter.timeStyle = .short
		formatter.dateFormat = "hh:mm a"
		formatter.locale = Locale.current
		formatter.timeZone = TimeZone.current
		let timeString = formatter.string(from: date)
		nextTimeLabel.stringValue = "Next scheduled horse moment: \(timeString)"
	}
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
