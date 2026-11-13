import CapcapSupport
import Foundation

package enum MainRunLoopScheduler {
    package static func perform(_ work: @escaping () -> Void) {
        CFRunLoopPerformBlock(CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue) {
            work()
        }
        CFRunLoopWakeUp(CFRunLoopGetMain())
    }

    package static func performInDefaultMode(_ work: @escaping () -> Void) {
        CFRunLoopPerformBlock(CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue) {
            work()
        }
        CFRunLoopWakeUp(CFRunLoopGetMain())
    }
}
