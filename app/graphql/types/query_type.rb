module Types
  class QueryType < Types::BaseObject
    field :projects, 'Project list', resolver: Resolvers::Projects

    field :project, 'Project by id', resolver: Resolvers::Project
  end
end
