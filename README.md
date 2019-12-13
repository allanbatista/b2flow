# B2Flow

É uma ferramenta para automatizar jobs de forma simples e transparente.

### Deploy

```
wget https://raw.githubusercontent.com/allanbatista/b2flow/master/docker/docker-compose-prod.yml -O docker-compose.yml
docker-compose -f docker-compose.yml up -d --force-recreate
```

### Configurações

**Banco de Dados**

O único banco de dados suportado é o mongo.

    B2FLOW__DATABASE__URI=mongodb://mongo:password@localhost:27017/b2flow_test?authSource=admin

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

### Query Parâmetros

Todos os endpoints Index possuem os seguintes parâmetros por padrão:

    int per_page: min 1 max 100
    int page: min 1 

#### Users

```
GET /users/me
X-Auth-Token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

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
GET /teams
X-Auth-Token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

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
GET /teams/x-team
X-Auth-Token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

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
GET /teams/x-team
X-Auth-Token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

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
PATCH /teams/new-team
X-Auth-Token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

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
X-Auth-Token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

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
X-Auth-Token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

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
X-Auth-Token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

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
X-Auth-Token: eyJhbGciOiJIUzI1NiJ9.eyJwYXlsb2FkIjp7ImlkIjoiODVkMzRiOGMtNWE1MC00OGY2LWJkOGMtZTAzNWQxOGEwY2RjIn0sImV4cCI6MTYwNjkzNTA0MH0.uVMaHgE3LugJu74k9pAU8sdSzF65z1RIa62RLNLwjFE

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
```
