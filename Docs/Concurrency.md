
# Table of content

- async/await, async let
- Task/TaskGroup
- Sendable
- Actor

## async/await, async let

### async let
- Normally, when call an `async` func, we need to use `await` keyword. But what if we want to call multiple `async` func simultaneous? => Use `async let`

```
func downloadImageAndMetadata(imageNumber: Int) async throws -> DetailedImage {
    async let image = downloadImage(imageNumber: imageNumber) // 1
    async let metadata = downloadMetadata(for: imageNumber)
    return try DetailedImage(image: await image, metadata: await metadata) // 2
}
```

1. Use `async let` to call `async` func simultaneous
2. Use `await` to wait for the result

## Task/TaskGroup

### Task 
```
    Task(priority: <TaskPriority?>, operation: <() async -> _>)
```

Static methods
```
- Task.sleep()
- Task.checkCancellation() // Check if Task has been cancelled
```

### withCheckedThrowingContinuation

- Use to wrap sync code with async code
- *It's a nice way to refactor old code to using async/await without rebuild everything from scratch*

*Before*
```
    func fetchSomething(completion: @escaping (Int) -> Void) {
        // Call some API
        completion(response)
    }
}
```

*With Async/Await*
```
    func fetchSomething() async throws {
        try await withCheckedThrowingContinuation({ c in
            // Call some API 
            c.resume(returning: response) // Must call `resume` once time
            c.resume(throwing: error)
        })
    }
```

> NOTE:
- Should call `resume` only once

### withTaskGroup/withThrowingTaskGroup

- Wait for multiple async func to finish execution (similar as DispatchGroup)

```
await withTaskGroup(of: String.self) { group -> String in
    group.addTask { "Hello" }
    group.addTask { "From" }
    group.addTask { "A" }
    group.addTask { "Task" }
    group.addTask { "Group" }
    
    var collected = [String]()
    for await value in group {
        collected.append(value)
    }
    
    return collected.joined(separator: " ")
}
```

```
func fetchAPIs<T: Decodable>(urls: [URL]) async throws -> [T] {
    try await withThrowingTaskGroup(of: T.self, body: { group in
        
        for url in urls {
            group.async {
                try await fetchAPI(url: url)
            }
        }
        
        var results = [T]()
        for try await result in group {
            results.append(result)
        }
        return results
    })
}
```

> NOTE:
- APIs in a group returns same DataType

## Sendable

- Sendable Type là kiểu dữ liệu mà có thể được chia sẽ một cách an toàn trong Concurrency.
```
Sendable Protocol
@Sendable
```

```
final class User: Sendable {
    let name: String
    init(name: String) {
        self.name = name
    }
}
```

## Actors
