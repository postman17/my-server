## Postgresql and Pgadmin with docker-compose

- Copy ```.env.db.example``` to ```.env.db``` and fill variables
- Copy ```.env.pgadmin.example``` to ```.env.pgadmin``` and fill variables

- ```docker-compose up```

- After first starting or after down container use: ```sudo chown -R 5050:5050 data/pgadmin```
