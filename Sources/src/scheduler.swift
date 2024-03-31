import Foundation

//@DocBrief("Scheduler class")
open class _scheduler_: NSObject {

    private var periodInMilliseconds: Int = 0
    private var action: action? = nil
    private var stopped = false
    private var timer: DispatchSourceTimer? = nil
    private let lock = NSRecursiveLock()

    public override init() {
        super.init()
    }

    open func startImmediately() -> Void {
        self.lock.lock()
        stopped = false
        do {
            try self.action?.invoke()
            if stopped {
                self.lock.unlock()
                return
            }
        } catch {
            print(error)
        }
        self.lock.unlock()
        startWithDelay()
    }

    open func startWithDelay() -> Void {
        self.lock.lock()
        stopped = false
        if (periodInMilliseconds >= 0) {
            let queue = DispatchQueue(label: "com.domain.app.timer." + NSUUID().uuidString)
            timer = DispatchSource.makeTimerSource(queue: queue)
            timer!.schedule(deadline: .now() + TimeInterval(periodInMilliseconds) / 1000.0, repeating: TimeInterval(periodInMilliseconds) / 1000.0)
            timer!.setEventHandler { [weak self] in
                guard let self = self else { return }
                self.lock.lock()
                if self.stopped {
                    self.lock.unlock()
                    return
                }
                do {
                    try self.action?.invoke()
                } catch {
                    print(error)
                }
                self.lock.unlock()
            }
            timer!.resume()
        } else {
            while (!stopped) {
                do {
                    try self.action?.invoke()
                } catch {
                    print(error)
                    break
                }
            } 
        }
        self.lock.unlock()
    }

    open func stop() -> Void {
        self.lock.lock()
        stopped = true
        if timer != nil {
            timer!.setEventHandler {}
            timer!.cancel()            
            timer = nil
        }
        self.lock.unlock()
    }

    public static func create(_ periodInMilliseconds : Int, _ action : action?) -> _scheduler_? {
        guard let action = action else { return nil }
        let scheduler = _scheduler_()
        scheduler.periodInMilliseconds = periodInMilliseconds
        scheduler.action = action
        return scheduler
    }
}
