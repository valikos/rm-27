module Resolvers
  class Project < Resolvers::Base
    type Types::ProjectType, null: false

    argument :id, ID, required: true

    def resolve(id:)
      ::Project.find(id)
    end
  end
end
