class ProjectSchema < GraphQL::Schema
  query(Types::QueryType)

  use GraphQL::Execution::Interpreter
  use GraphQL::Batch
end

GraphQL::Errors.configure(ProjectSchema) do
  rescue_from ActiveRecord::RecordNotFound do |exception|
    nil
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    GraphQL::ExecutionError.new(exception.record.errors.full_messages.join("\n"))
  end

  rescue_from StandardError do |exception|
    GraphQL::ExecutionError.new("Please try to execute the query for this field later")
  end

  rescue_from Exception do |exception|
    GraphQL::ExecutionError.new(exception.message)
  end
end
