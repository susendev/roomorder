import Fluent

struct CreateTodo: AsyncMigration {
    func prepare(on database: Database) async throws {
        do {
            try await database.schema("todos")
            .id()
            .field("title", .string, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .create()
        } catch {
            print(error)
        }
        
    }

    func revert(on database: Database) async throws {
        try await database.schema("todos").delete()
    }
}
