module Types
  class ProjectType < Types::BaseObject
    field :id, ID, 'Project id', null: false
    field :title, ID, 'Project title', null: false
    field :body, ID, 'Project body', null: false
    field :tasks, [TaskType], 'Project tasks with n+1', null: true
    field :loader_tasks, [TaskType], 'Project tasks with loader', null: true

    def tasks
      object.tasks
    end

    def loader_tasks
      RecordLoader.for(Task).load_many(object.tasks.ids)
    end
  end
end
