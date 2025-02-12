import UIKit

struct TrackerModel {
    let id: UUID
    let name: String
    let color: Int
    let emoji: String
    let schedule: Set<WeekDay>
    let creationDate: Date?
}
