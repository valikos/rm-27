module Types
  class CommentType < Types::BaseObject
    field :id, ID, 'Comment id', null: false
    field :title, String, 'Comment title', null: false
    field :body, String, 'Comment body', null: false

    field :task, TaskType, 'Comment task', null: false
  end
end
