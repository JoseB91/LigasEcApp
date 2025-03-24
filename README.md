# LigasEc 
<!-- ![](https://github.com/essentialdevelopercom/essential-feed-case-study/workflows/CI-iOS/badge.svg) -->
<!-- Add badge -->

## Leagues Feature Specs

### Story: Customer requests to see Ecuadorian leagues

### Narrative

```
As an online/offline customer
I want the app to show ecuadorian leagues
So I can choose one of them 
```

#### Scenarios (Acceptance criteria)

```
Given an online/offline customer
  And the cache is empty
 When the customer requests to see the leagues
 Then the app should display two hardcoded leagues
  And save those leagues to cache 
  And if saving fails, delete the cache
  
Given an online/offline customer
  And there's a cached version of the leagues
 When the customer requests to see the leagues
 Then the app should display two hardcoded leagues
  And don't save those leagues to cache
```

## Use Cases

### Load Leagues Use Case

#### Data:
- Hardcoded leagues

#### Primary course (happy path):
1. System creates leagues from hardcoded data.
2. System shows leagues.

---

### Load League Image From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute get command.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System delivers image data.

#### Cancel course:
1. System does not deliver image data nor error. //TODO: Implement

#### Any error – error course (sad path):
1. System delivers respective error.

---

### Load League Image From Local Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute load command.
2. System retrieves data from the cache.
3. System delivers cached image data.

#### Cancel course:
1. System does not deliver image data nor error. // TODO: Implement

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path):
1. System delivers not found error.

---

### Save League Image To Local Use Case

#### Data:
- Image Data

#### Primary course (happy path):
1. Execute save command.
2. System caches image data.

#### Saving error course (sad path):
1. System delivers error.

---

### Save Leagues To Local Use Case

#### Data:
- League

#### Primary course (happy path):
1. Execute save command.
3. System encodes leagues.
4. System timestamps the new cache.
5. System saves new cache data.

#### Saving error course (sad path):
1. System deletes cache.

#### Saving and deleting cache error course (sad path):
1. System delivers error.
---

### Validate League Cache Use Case

#### Primary course:
1. Execute "Validate Cache" command upon app launch.
2. System retrieves leagues data from cache.
3. System validates cache is less than seven days old.

#### Retrieval error course (sad path):
1. System deletes cache.

#### Expired cache course (sad path): 
1. System deletes cache.

---

## Flowchart

## Model Specs

### League

| Property      | Type                |
|---------------|---------------------|
| `id`          | `String`            |
| `stageId`     | `String`            |
| `name`        | `String`            |
| `logoURL`     | `URL`               |


## Teams Feature Specs

### Story: Customer requests to see leagues' teams

### Narrative #1

```
As an online customer
I want the app to load teams of a selected ecuadorian league
So I can choose one of them
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
  And the cache is empty
 When the customer requests to see teams of a league
 Then the app should display all teams from remote
  And save those teams to cache

Given the customer has connectivity
  And there's a cached version of the teams
 When the customer requests to see teams of a league
 Then the app should display all teams from cache
  And don't save those teams to cache
```

### Narrative #2

```
As an offline customer
I want the app to load teams of a selected ecuadorian league
So I can choose one of them
```

#### Scenarios (Acceptance criteria)

```
Given the customer doesn't have connectivity
  And the cache is empty
 When the customer requests to see the teams
 Then the app should display an error message
 
Given the customer doesn't have connectivity
  And there's a cached version of the teams
 When the customer requests to see the teams
 Then the app should display the teams from cache
```

## Use Cases

### Load Image Comments From Remote Use Case

#### Data:
- ImageID

#### Primary course (happy path):
1. Execute "Load Image Comments" command with above data.
2. System loads data from remote service.
3. System validates data.
4. System creates comments from valid data.
5. System delivers comments.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

## Model Specs

### Image Comment

| Property          | Type                    |
|-------------------|-------------------------|
| `id`              | `UUID`                  |
| `message`         | `String`                  |
| `created_at`      | `Date` (ISO8601 String) |
| `author`             | `CommentAuthorObject`   |

### Image Comment Author

| Property          | Type                |
|-------------------|---------------------|
| `username`         | `String`              |

### Payload contract

```
GET /image/{image-id}/comments

2xx RESPONSE

{
    "items": [
        {
            "id": "a UUID",
            "message": "a message",
            "created_at": "2020-05-20T11:24:59+0000",
            "author": {
                "username": "a username"
            }
        },
        {
            "id": "another UUID",
            "message": "another message",
            "created_at": "2020-05-19T14:23:53+0000",
            "author": {
                "username": "another username"
            }
        },
        ...
    ]
}
```

---

## App Architecture


