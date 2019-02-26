import Vapor
import Foundation

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    router.get("hello", "vapor") { req in
        return "Hello Vapor!"
    }

    router.get("hello", String.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
        return "Hello \(name)!"
    }

    router.post("info") { req -> String in
        let data = try req.content.syncDecode(InfoData.self)
        return "Hello \(data.name)!"
    }

    router.post("info-response") { req -> InfoResponse in
        let data = try req.content.syncDecode(InfoData.self)
        return InfoResponse(request: data)
    }

    router.get("date") { req -> String in
        return("Today is \(Date())")
    }

    router.get("counter", Int.parameter) { req -> CounterResponse in
        let givenNumber = try req.parameters.next(Int.self)
        return CounterResponse(number: givenNumber)
    }

    router.post("user-info") { req -> String in
        let data = try req.content.syncDecode(NameAndAgeRequest.self)
        return("Your name is \(data.name) and you are \(data.age)")
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

struct InfoData: Content {
    let name: String
}

struct InfoResponse: Content {
    let request: InfoData
}

struct CounterResponse: Content {
    let number: Int
}

struct NameAndAgeRequest: Content {
    let name: String
    let age: Int
}
