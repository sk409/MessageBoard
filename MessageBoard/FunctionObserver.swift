
class FunctionObserver {
    
    private(set) var successful = false
    
    private let file: String
    private let function: String
    private var failureHandler: (() -> Void)?
    
    init(file: String = #file, function: String = #function) {
        self.file = file
        self.function = function
    }
    
    init(file: String = #file, function: String = #function, failureHandler: @escaping () -> Void) {
        self.file = file
        self.function = function
        self.failureHandler = failureHandler
    }
    
    func complete() {
        successful = true
    }
    
    deinit {
        if !successful {
            print("=======================================")
            print("関数が正常に終了しませんでした")
            print(file + ": " + function)
            print("=======================================")
            guard let failureHandler = self.failureHandler else {
                return
            }
            failureHandler()
        }
    }
    
}
