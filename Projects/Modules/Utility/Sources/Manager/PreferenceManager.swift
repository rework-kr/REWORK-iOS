import Foundation

/// UserDefaults에 편리하게 접근하기 위한 클래스 정의
public final class PreferenceManager {
    public static let shared: PreferenceManager = PreferenceManager()

    /// UserDefaults에 저장 된 데이터에 접근하기 위한 키 값의 나열.
    enum Constants: String {
        case user
        case calendarIsOpen // HomeView 캘린더 오픈 여부
        case uncompletedAgendaList // 아젠다 딕셔너리
        case completedAgendaList
    }

    @UserDefaultWrapper(key: Constants.calendarIsOpen.rawValue, defaultValue: nil)
    public static var calendarIsOpen: Bool?

    @UserDefaultWrapper(key: Constants.uncompletedAgendaList.rawValue, defaultValue: nil)
    public static var uncompletedAgendaList: [AgendaDate : [AgendaInfo]]?
    
    @UserDefaultWrapper(key: Constants.completedAgendaList.rawValue, defaultValue: nil)
    public static var completedAgendaList: [AgendaDate : [AgendaInfo]]?
}

@propertyWrapper
public final class UserDefaultWrapper<T: Codable> {
    private let key: String
    private let defaultValue: T?

    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
                    return lodedObejct
                }
            } else if UserDefaults.standard.array(forKey: key) != nil {
                return UserDefaults.standard.array(forKey: key) as? T
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: key)
            }
        }
    }
}
