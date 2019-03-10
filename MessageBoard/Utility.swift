import Foundation

func getClassName<T>(object: T) -> String {
    return String(describing: type(of: object))
}
