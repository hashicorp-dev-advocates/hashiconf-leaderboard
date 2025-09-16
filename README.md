# hashiconf-leaderboard

Leaderboard for HashiConf Activations.

```
                   Frontend                          Admin
                       │                              │
                       │                              │
                       │                              │
                       └────────► API◄────────────────┘
GET /teams/activations/{name}      │     GET /login (Authorization: username:password) (returns token)
                                   │     POST /teams (Authorization: token)
                                   │     DELETE /teams/{id} (Authorization: token)
                                   │
                                   ▼
                                Database
```

## Infrastructure

All infrastructure for the application is set up in `infrastructure/`
using [HCP Terraform](https://app.terraform.io/app/hashicorp-team-da-beta/workspaces/leaderboard-infrastructure/runs).

> Region is us-west-2 for 2025.

### Database

The database uses AWS PostgreSQL on RDS in multi-az configuration.

It has two users:

- Admin (set by RDS)
- Application (created by script on bastion and stored in AWS Secrets Manager)

To access the database, you can connect to the bastion through
EC2 instance connect on the AWS console. It has scripts
to connect and set up the database.

```bash
## On bastion

$ sudo su
$ source /opt/database/connection.env
$ cat /opt/database/setup.sql
```

It has three tables:

- Teams: for all teams
- Users: for admin users
- Tokens: for tokens generated to access API endpoints

### Services

Services run on AWS App Runner using images pushed to ECR
by GitHub Actions.

## Frontend

The frontend contains leaderboards for each of the activations.
It uses Ember (since it leverages [Helios Design System](https://helios.hashicorp.design/)).

## Admin

The administrative dashboard uses React. Administrators must log in by username and password
before they can manage teams.

## API

The API allows the frontend and admin dashboard to interface with the database.

Endpoints include:

- GET `/health/livez`: Liveness
- GET `/health/ready`: Readiness
- GET `/login`: Set `Authorization: username:password` header to log in and get a token.
- GET `/logout`: Set `Authorization: token` header to invalidate token.
- GET `/teams`: Gets a list of all teams
- GET `/teams/{id}`: Get a team by ID
- GET `/teams/activations/{name}`: Get a list of teams by activation, sorted by time.
- POST `/teams`: Set `Authorization: token` header to create a team. Example payload: `{"name":"My team","time":123,"activation":"robots"}`.
- DELETE `/teams/{id}`: Set `Authorization: token` header to delete a team by ID.
