# SANDBOX

To run sandbox you need fetch this repo and set up docker.

```
docker-compose up --build
```

Make sure docker have finished setup. Then you can visit `http://localhost:3000/graphiql`.
`Graphiql` is an in-browser IDE for exploring GraphQL.

## N+1
To see how `n+1` works use next query:

```
query {
  projects {
    id
    title
    body
    tasks {
      id
      title
      body
      comments {
        id
        title
        body
      }
    }
  }
}
```

After request is done check you docker console. You will see something like:

```
app_1  | Started POST "/graphql" for 172.18.0.1 at 2019-05-15 18:50:59 +0000
app_1  | Cannot render console from 172.18.0.1! Allowed networks: 127.0.0.1, ::1, 127.0.0.0/127.255.255.255
app_1  | Processing by GraphqlController#execute as */*
app_1  |   Parameters: {"query"=>"query {\n  projects {\n    id\n    title\n    body\n    tasks {\n      id\n      title\n      body\n      comments {\n        id\n      \ttitle\n      \tbody\n      }\n    }\n  }\n}", "variables"=>nil, "graphql"=>{"query"=>"query {\n  projects {\n    id\n    title\n    body\n    tasks {\n      id\n      title\n      body\n      comments {\n        id\n      \ttitle\n      \tbody\n      }\n    }\n  }\n}", "variables"=>nil}}
app_1  |   Project Load (0.4ms)  SELECT "projects".* FROM "projects"
app_1  |   ↳ app/controllers/graphql_controller.rb:11
app_1  |   Task Load (0.3ms)  SELECT "tasks".* FROM "tasks" WHERE "tasks"."project_id" = $1  [["project_id", 1]]
app_1  |   ↳ app/controllers/graphql_controller.rb:11
app_1  |   Comment Load (0.2ms)  SELECT "comments".* FROM "comments" WHERE "comments"."task_id" = $1  [["task_id", 1]]
app_1  |   ↳ app/controllers/graphql_controller.rb:11
...
```

I implemented one field for project with batch loader.
Please try next query.

```
query {
  projects {
    id
    title
    body
    loaderTasks {
      id
      title
      body
      comments {
        id
        title
        body
      }
    }
  }
}
```

In console you can find:

```
app_1  |   Task Load (0.6ms)  SELECT "tasks".* FROM "tasks" WHERE "tasks"."id" IN ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $60, $61, $62, $63, $64, $65)  [["id", 1], ["id", 2], ["id", 3], ["id", 4], ["id", 5], ["id", 6], ["id", 7], ["id", 8], ["id", 9], ["id", 10], ["id", 11], ["id", 12], ["id", 13], ["id", 14], ["id", 15], ["id", 16], ["id", 17], ["id", 18], ["id", 19], ["id", 20], ["id", 21], ["id", 22], ["id", 23], ["id", 24], ["id", 25], ["id", 26], ["id", 27], ["id", 28], ["id", 29], ["id", 30], ["id", 31], ["id", 32], ["id", 33], ["id", 34], ["id", 35], ["id", 36], ["id", 37], ["id", 38], ["id", 39], ["id", 40], ["id", 41], ["id", 42], ["id", 43], ["id", 44], ["id", 45], ["id", 46], ["id", 47], ["id", 48], ["id", 49], ["id", 50], ["id", 51], ["id", 52], ["id", 53], ["id", 54], ["id", 55], ["id", 56], ["id", 57], ["id", 58], ["id", 59], ["id", 60], ["id", 61], ["id", 62], ["id", 63], ["id", 64], ["id", 65]]
```

Thats it. N+1 solved.

## Dangerouse query

This GraphQL server don't have any restrictions for incoming query.
We can try some worth things. For example ask from api backward associations.

```
query {
  projects {
    id
    title
    body
    tasks {
      id
      title
      body
      project {
        id
        title
        body
      }
      comments {
        id
        title
        body
        task {
          id
          title
          body
          project {
            id
            title
            body
            tasks {
              id
              title
              body
              project {
                id
                title
                body
              }
              comments {
                id
                title
                body
              }
            }
          }
        }
      }
    }
  }
}
```

After this query you will notice how execution time is changed.
This is just an easy example. In real cases that can put your server on his knees.
Be careful.
