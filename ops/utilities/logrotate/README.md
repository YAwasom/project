## using logrotate

- ensure logrotate is installed
- Write [config file](./mongod) to `/etc/logrotate.d/`
- Test it out via -d and --force

```bash
logrotate -d /etc/logrotate.d/mongod
logrotate --force /etc/logrotate.d/mongod
```

```bash
# https://docs.mongodb.com/manual/tutorial/rotate-log-files/#forcing-a-log-rotation-with-sigusr1
postrotate
    /bin/kill -SIGUSR1 `cat /var/run/mongo/mongod.pid 2> /dev/null` 2> /dev/null || true
endscript
```

```bash
# -d nice for basic testing
# --force will force rotation without validation of rules etc
[root@mongo-dev-a logrotate.d]# logrotate -d /etc/logrotate.d/mongod
reading config file mongod
reading config info for /log/mongodb/*.log

Handling 1 logs

rotating pattern: /log/mongodb/*.log  104857600 bytes (4 rotations)
empty log files are not rotated, old logs are removed
considering log /var/log/mongodb/mongod.log
  log does not need rotating
not running postrotate script, since no logs were rotated
```

## generating test data for rotation tests

```bash
head -c 50M </dev/urandom >/var/log/mongodb/mongod.log
```