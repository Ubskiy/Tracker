import UIKit

struct TrackerModel {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekDay>
}
