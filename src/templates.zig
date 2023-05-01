pub const DOCKER_COMPOSE_TEMPLATE =
    \\version: "3"
    \\
    \\services:
    \\
;

pub const NVIM_CONTAINER =
    \\  nvim:
    \\    image: wmb1207/{s}awesome_vim:latest
    \\    volumes:
    \\      - ./:/app
    \\
;

pub const MYSQL =
    \\  database:
    \\    image: mysql:{s}
    \\    restart: always
    \\    environment:
    \\      MYSQL_ROOT_PASSWORD: root_password
    \\      MYSQL_USER: {s}
    \\      MYSQL_PASSWORD: {s}
    \\      MYSQL_DATABASE: {s}
    \\    expose:
    \\      - 3306
    \\    ports:
    \\      - {s}:3306
    \\
;

pub const TASKFILE =
    \\version: '3'
    \\
    \\tasks:
    \\  code:
    \\    cmds:
    \\      - docker-compose run nv
    \\    silent: true
;

pub const TASK_FILE_DATABASE_CMD =
    \\
    \\
;

pub const POSTGRESQL =
    \\  database:
    \\    image: postgresql:{s}
    \\    restart: always
    \\    environment:
    \\      MARIADB_ROOT_PASSWORD: root_password
    \\      MARIADB_DATABASE: {s}
    \\      MARIADB_USER: {s}
    \\      MARIADB_PASSWORD: {s}
    \\    expose:
    \\      - 3306
    \\    ports:
    \\      - {s}:3306
    \\
;

pub const MARIADB =
    \\  database:
    \\    image: mariadb:{s}
    \\    restart: always
    \\    environment:
    \\      MARIADB_ROOT_PASSWORD: root_password
    \\      MARIADB_DATABASE: {s}
    \\      MARIADB_USER: {s}
    \\      MARIADB_PASSWORD: {s}
    \\    expose:
    \\      - 3306
    \\    ports:
    \\      - {s}:3306
    \\
;

pub const MAIN_PY =
    \\def main():
    \\    print("Hello World")
    \\
    \\if __name__ == "__main__":
    \\    main()
    \\
;
