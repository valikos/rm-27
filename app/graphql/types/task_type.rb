module Types
  class TaskType < Types::BaseObject
    field :id, ID, 'Task id', null: false
    field :title, String, 'Task title', null: false
    field :body, String, 'Task body', null: false
    field :comments, [CommentType], 'Task comments', null: true

    field :project, ProjectType, 'Task project', null: false
  end
end
