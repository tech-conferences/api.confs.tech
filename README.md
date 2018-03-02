# README

## Configuration

Set the configuration you want in `config/application.rb`:

* `gh_token`: GitHub authorization token
* `gh_repo`: GitHub repository

### Testing

As for now, feature set is limited, but you can hit the following endpoint:

* `/`: List all the closed Pull-Requests on the repository
* `/github/create`: Create a Pull-Request under the `gh_repo`

### Authentication

Token-based authentication.

* Create a user: 
```
User.create!(email: 'example@mail.com' , password: '123123123' , password_confirmation: '123123123')
```

Now start the server curl it to query a token:

```
curl -H "Content-Type: application/json" -X POST -d '{"email":"example@mail.com","password":"123123123"}' http://localhost:3000/authenticate
```

Then use it in your request:

```
curl -H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE0NjA2NTgxODZ9.xsSwcPC22IR71OBv6bU_OGCSyfE89DvEzWfDU0iybMA" http://localhost:3000/
```
