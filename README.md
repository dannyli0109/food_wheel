- #### Ideas
  - ~~boardgame meetup app~~
  - restaurant picker
- #### wireframing
- #### determining the database schema
---  
users
  |id| email | password_digest     |
  |--- |--- |---
  | 1 | a@test.com      | dj2313jk

places
  | id | name     |vicinity|place_lat|place_lon|place_id
  |--- |--- |---|---|---|---|
  | 1| name of restaurant  | address|-32|140|google place id

visits
|id| createion_time | place_id  | user_id|
|--- |--- |---|---|
| 1 | 2017-07-07 12:59 | refers to place table|refers to the users table|
---
##How to use
- This app require user to provide their locational informations
- spin the wheel to get a random place
- then you can tag it or get another one
- in the profile page, you will get 10 recent visit on the map and your history
