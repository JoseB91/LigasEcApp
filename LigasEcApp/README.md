
# LigasEc 
![](https://github.com/essentialdevelopercom/essential-feed-case-study/workflows/CI-iOS/badge.svg) ![](https://github.com/essentialdevelopercom/essential-feed-case-study/workflows/CI-macOS/badge.svg) ![](https://github.com/essentialdevelopercom/essential-feed-case-study/workflows/Deploy/badge.svg)

## Leagues Feature Specs

### Story: Customer requests to see Ecuadorian leagues

### Narrative #1

```
As an online customer
I want the app to automatically load ecuadorian leagues
So I can choose one of them 
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
  And the cache is empty
 When the customer requests to see the leagues
 Then the app should display the latest leagues from remote
  And replace the cache with those leagues
  
Given the customer has connectivity
  And there’s a cached version of the leagues
 When the customer requests to see the leagues
 Then the app should display the latest leagues from local
  And replace the cache with those leagues
```

### Narrative #2

```
As an offline customer
I want the app to show the latest saved version of ecuadorian leagues
So I can choose one of them
```

#### Scenarios (Acceptance criteria)

```
Given the customer doesn't have connectivity
  And there’s a cached version of the leagues
  And the cache is less than seven days old
 When the customer requests to see the leagues
 Then the app should display the latest leagues from local

Given the customer doesn't have connectivity
  And there’s a cached version of the leagues
  And the cache is seven days old or more
 When the customer requests to see the leagues
 Then the app should display an error message

Given the customer doesn't have connectivity
  And the cache is empty
 When the customer requests to see the leagues
 Then the app should display an error message
```

## Use Cases

### Load Leagues From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute get command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates leagues from valid data.
5. System delivers leagues.

#### Invalid data – error course (sad path): //TODO: Improve
1. System delivers invalid data error.

#### Other errors – error course (sad path): //TODO: Validate
1. System delivers respective error.
---

### Load League Image From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute get command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System delivers image data.

#### Cancel course:
1. System does not deliver image data nor error. //TODO: Implement

#### Any error – error course (sad path):
1. System delivers respective error.

---

### Load Leagues From Local Use Case

#### Primary course:
1. Execute load command with above data.
2. System retrieves leagues data from cache.
3. System validates cache is less than seven days old.
4. System creates leagues from cached data.
5. System delivers leagues.

#### Retrieval error course (sad path):
1. System delivers error.

#### Expired cache course (sad path): 
1. System delivers no leagues.

#### Empty cache course (sad path): 
1. System delivers no leagues.

---

### Load League Image From Local Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute load command with above data.
2. System retrieves data from the cache.
3. System delivers cached image data.

#### Cancel course:
1. System does not deliver image data nor error. // TODO: Implement

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path):
1. System delivers not found error.

---

### Validate League Cache Use Case

#### Primary course:
1. Execute "Validate Cache" command with above data.
2. System retrieves leagues data from cache.
3. System validates cache is less than seven days old.

#### Retrieval error course (sad path):
1. System deletes cache.

#### Expired cache course (sad path): 
1. System deletes cache.

---

### Save Leagues To Local Use Case

#### Data:
- League

#### Primary course (happy path):
1. Execute save command with above data.
2. System deletes old cache data.
3. System encodes leagues.
4. System timestamps the new cache.
5. System saves new cache data.

#### Deleting error course (sad path):
1. System delivers error.

#### Saving error course (sad path):
1. System delivers error.

---

### Save League Image To Local Use Case

#### Data:
- Image Data

#### Primary course (happy path):
1. Execute save command with above data.
2. System caches image data.

#### Saving error course (sad path):
1. System delivers error.

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

### Payload contract

```
GET /feed

200 RESPONSE

{
    "items": [
        {
            "id": "a UUID",
            "description": "a description",
            "location": "a location",
            "image": "https://a-image.url",
        },
        {
            "id": "another UUID",
            "description": "another description",
            "image": "https://another-image.url"
        },
        {
            "id": "even another UUID",
            "location": "even another location",
            "image": "https://even-another-image.url"
        },
        {
            "id": "yet another UUID",
            "image": "https://yet-another-image.url"
        }
        ...
    ]
}
```

---

## Image Comments Feature Specs

### Story: Customer requests to see image comments

### Narrative

```
As an online customer
I want the app to load image commments
So I can see how people are engaging with images in my feed
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
 When the customer requests to see comments on an image
 Then the app should display all comments for that image
```

```
Given the customer doesn't have connectivity
 When the customer requests to see comments on an image
 Then the app should display an error message
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

