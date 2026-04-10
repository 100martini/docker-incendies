# docker-incendies 🏗️

> one container is not enough.

a fully containerized infrastructure built from scratch — no official images used (except alpine). everything runs in docker, everything talks through a private network, everything is on fire (in a good way).

---

## what's inside

| container | does what |
|---|---|
| **nginx** | the bouncer. tls only (1.2/1.3), forwards php to wordpress |
| **wordpress** | the app. php-fpm, wired to mariadb + redis |
| **mariadb** | the brain. stores everything wordpress cares about |
| **redis** | the memory. caches wordpress objects so mariadb can breathe |
| **ftp** | file access to wordpress volume via vsftpd |
| **adminer** | database ui for when you don't want to type sql at 2am |
| **portainer** | docker management ui, because `docker ps` gets old |
| **static** | a tiny python http server serving a one-page site |

all containers are built on `alpine:3.18`. no bloat.

---

## architecture

```
internet
    │
   443 (tls)
    │
  nginx ──────────► wordpress (php-fpm :9000)
                        │           │
                     mariadb      redis
                     (:3306)     (:6379)

  ftp (:21)        ──► wordpress_files volume
  adminer (:8080)  ──► mariadb
  portainer (:9000)──► docker socket
  static (:8081)   ──► standalone
```

secrets are never in env files — they live in `secrets/` and are mounted at runtime via docker secrets.

---

## setup

**1. clone**
```bash
git clone https://github.com/100martini/docker-incendies.git
cd docker-incendies
```

**2. create your secrets**
```bash
mkdir secrets
echo "your_root_password"  > secrets/db_root_password.txt
echo "your_db_password"    > secrets/db_password.txt
echo "your_admin_password" > secrets/admin_password.txt
echo "your_user_password"  > secrets/user_password.txt
echo "your_ftp_password"   > secrets/ftp_password.txt
echo "your_redis_password" > secrets/redis_password.txt
```

**3. configure your environment**
```bash
cp srcs/.env.template srcs/.env
# fill in the values
```

**4. add your domain to /etc/hosts**
```bash
echo "127.0.0.1 yourdomain.42.fr" | sudo tee -a /etc/hosts
```

**5. ignite**
```bash
make
```

---

## commands

```bash
make          # setup + build + run
make up       # start containers
make down     # stop containers (data preserved)
make clean    # same as down
make fclean   # nukes everything including volumes
make re       # fclean + make
```

---

## services map

once running:

| url | service |
|---|---|
| `https://yourdomain.42.fr` | wordpress |
| `http://localhost:8080` | adminer |
| `http://localhost:8081` | static site |
| `http://localhost:9000` | portainer |
| `ftp://localhost:21` | ftp |

---

## project structure

```
.
├── Makefile
├── secrets/          ← not committed (gitignored)
└── srcs/
    ├── .env          ← not committed (gitignored)
    ├── .env.template
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        ├── wordpress/
        ├── mariadb/
        └── bonus/
            ├── redis/
            ├── ftp/
            ├── adminer/
            ├── portainer/
            └── static/
```

---

made at **1337 benguerir** · 42 network  
`wel-kass` · [intra](https://profile.intra.42.fr/users/wel-kass)
