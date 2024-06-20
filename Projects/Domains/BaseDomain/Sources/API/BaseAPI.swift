import Foundation

public func config(key: String) -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: Any] else {
        return ""
    }
    return secrets[key] as? String ?? "not found key"
}

// MARK: - BASE_URL
public func BASE_URL() -> String {
    #if DEBUG
        return config(key: "BASE_DEV_URL")
    #else
        return config(key: "BASE_PROD_URL")
    #endif
}

// MARK: - Domain
public func RWDOMAIN_AUTH() -> String {
    return config(key: "RWDOMAIN_AUTH")
}

public func RWDOMAIN_DAILY_AGENDA() -> String {
    return config(key: "RWDOMAIN_DAILY_AGENDA")
}

public func RWDOMAIN_MONTHLY_AGENDA() -> String {
    return config(key: "RWDOMAIN_MONTHLY_AGENDA")
}
