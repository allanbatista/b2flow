# B2Flow

É uma ferramenta para automatizar jobs de forma simples e transparente.

### API

Para fazer qualquer interação com a API interna, é necessário ter um token
de authenticação que é gerada como mostra o exemplo à baixo.

```
POST /authentications
Content-Type: application/json

{
    "email": "allan.batista@b2wdigital.com",
    "password": "password"
}

---

{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE"
}
```

#### Users

```
GET /users/me
x-auth-token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

---

{
    "id": "85d34b8c-5a50-48f6-bd8c-e035d18a0cdc",
    "email": "allan.batista@b2wdigital.com",
    "created_at": "2019-12-02T18:48:34.561+0000",
    "updated_at": "2019-12-02T18:48:34.561+0000"
}
```

## Resources

![](resources/images/project-organize.png)

### TEAMS

Um time pode ter muitos projetos e é a unidade macro de gerenciamento.

**index**

```
GET /projects
x-auth-token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

---
status: 200

[
    {
        "id": "d46d0e86-7e3e-4bfe-93ad-8293148f4d3e",
        "name": "x-team",
        "created_at": "2019-12-02T18:47:22.637+0000",
        "updated_at": "2019-12-02T18:47:22.637+0000"
    }
]
```

**show**

```
GET /projects/x-team
x-auth-token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

---
status: 200

{
    "id": "d46d0e86-7e3e-4bfe-93ad-8293148f4d3e",
    "name": "x-team",
    "created_at": "2019-12-02T18:47:22.637+0000",
    "updated_at": "2019-12-02T18:47:22.637+0000"
}
```

**create**

```
GET /projects/x-team
x-auth-token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

{
  "name": "new-team"
}

---
status: 201

{
    "id": "b14ef17f-581e-4a91-a154-017116e39a57",
    "name": "new-team",
    "created_at": "2019-12-02T18:58:41.906+0000",
    "updated_at": "2019-12-02T18:58:41.906+0000"
}
```

**update**

```
PATCH /projects/new-team
x-auth-token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

{
  "name": "other-name"
}

---
status: 200

{
    "id": "b14ef17f-581e-4a91-a154-017116e39a57",
    "name": "other-name",
    "created_at": "2019-12-02T18:58:41.906+0000",
    "updated_at": "2019-12-02T19:01:47.761+0000"
}
```

### PROJECTS

É a unidade de gerenciamento de um projeto. Um projeto pode ter multiplos jobs.

**index**

lista projetos de um time

```
GET /teams/x-team/projects
x-auth-token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

---
status: 200

[
    {
        "id": "27c84cc3-a267-4f3e-bae8-f02734bfb143",
        "name": "x-project",
        "team_id": "d46d0e86-7e3e-4bfe-93ad-8293148f4d3e",
        "created_at": "2019-12-02T18:47:22.659+0000",
        "updated_at": "2019-12-02T18:47:22.659+0000"
    }
]
```

**show**

```
GET /teams/x-team/projects/x-project
x-auth-token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

---
status: 200

{
    "id": "27c84cc3-a267-4f3e-bae8-f02734bfb143",
    "name": "x-project",
    "team_id": "d46d0e86-7e3e-4bfe-93ad-8293148f4d3e",
    "created_at": "2019-12-02T18:47:22.659+0000",
    "updated_at": "2019-12-02T18:47:22.659+0000"
}
```

**create**

```
POST /teams/x-team/projects
x-auth-token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

{
	"name": "new-project"
}

---
status: 201

{
    "id": "9ec3f223-17e4-4f06-b995-254b3d39a985",
    "name": "new-project",
    "team_id": "d46d0e86-7e3e-4bfe-93ad-8293148f4d3e",
    "created_at": "2019-12-02T19:05:27.260+0000",
    "updated_at": "2019-12-02T19:05:27.260+0000"
}
```

**update**

```
PATCH /teams/x-team/projects/new-project
x-auth-token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

{
	"name": "other-project"
}

---
status: 200

{
    "team_id": "d46d0e86-7e3e-4bfe-93ad-8293148f4d3e",
    "id": "9ec3f223-17e4-4f06-b995-254b3d39a985",
    "name": "other-project",
    "created_at": "2019-12-02T19:05:27.260+0000",
    "updated_at": "2019-12-02T19:06:56.263+0000"
}
```

### Job

É a unidade de gerenciamento de execução de um job, é a menor unidade de gerenciamento.

**index**

```
GET /teams/x-team/projects/x-project/jobs
x-auth-token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

---
status: 200

[
    {
        "id": "004415c5-fc9f-4c07-a874-a35d19e186a3",
        "name": "x-job-0",
        "project_id": "27c84cc3-a267-4f3e-bae8-f02734bfb143",
        "engine": "docker",
        "cron": null,
        "start_at": null,
        "end_at": null,
        "enable": true,
        "created_at": "2019-12-02T18:47:22.677+0000",
        "updated_at": "2019-12-02T18:47:22.677+0000"
    }
]
```

**show**

```
GET /teams/x-team/projects/x-project/jobs/x-job-0
x-auth-token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

---
status: 200

{
    "id": "004415c5-fc9f-4c07-a874-a35d19e186a3",
    "name": "x-job-0",
    "project_id": "27c84cc3-a267-4f3e-bae8-f02734bfb143",
    "engine": "docker",
    "cron": null,
    "start_at": null,
    "end_at": null,
    "enable": true,
    "created_at": "2019-12-02T18:47:22.677+0000",
    "updated_at": "2019-12-02T18:47:22.677+0000"
}
```

**create**

```
POST /teams/x-team/projects/x-project/jobs
x-auth-token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

{
    "name": "new-job",
    "engine": "docker",
    "cron": "* * * * *",
    "start_at": "2020-01-01T00:00:00.000+0000"
}

---
status: 200

{
    "id": "44d2c451-bad2-4ff1-98e7-74fece3ffd16",
    "name": "new-job",
    "project_id": "27c84cc3-a267-4f3e-bae8-f02734bfb143",
    "engine": "docker",
    "cron": "* * * * *",
    "start_at": "2020-01-01T00:00:00.000+0000",
    "end_at": null,
    "enable": true,
    "created_at": "2019-12-02T19:51:32.878+0000",
    "updated_at": "2019-12-02T19:51:32.878+0000"
}
```


### Versions

Versions são versões do código de um job.

## Start Project

Para iniciar localmente basta utilizar o `docker-compose up` para subir em modo de teste.

### Iniciando manualmente

```bash
# build b2flow base image
docker build -t b2flow-base -f docker/Dockefile-base .

# build b2flow image
docker build -t b2flow -f docker/Dockefile-base .

# iniciando o webapp
docker run --rm -it -p 3000:3000 b2flow webapp

# iniciando o scheduler
docker run --rm -it b2flow scheduler
```
