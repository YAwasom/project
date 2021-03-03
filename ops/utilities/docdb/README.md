# Amazon DocumentDB Index Tool

[amazon documentdb using the offline method](https://aws.amazon.com/blogs/database/migrate-from-mongodb-to-amazon-documentdb-using-the-offline-method/)

[troubleshooting index creation](https://docs.aws.amazon.com/documentdb/latest/developerguide/troubleshooting.index-creation.html)

[manage scaling db instances](https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-manage-performance.html#db-cluster-manage-scaling-instance)

## Overview

Pre-creating indexes can dramatically reduce the overall restore time because the indexes can be populated in parallel while restoring, rather than serially after data is restored with mongorestore.

So rollout for new docdb migrations is as follows:

- Dump the indexes from atlas using [documentdb_index_tool.py](./documentdb_index_tool.py) (has been modified to support atlas)

- Dump collection data from mongo atlas using `mongodump`

- Check the indexes for issues
  
- Drop any existing collections in documentdb
  - `db.<collection-name>.drop();`

- Import indexes to documentdb using [documentdb_index_tool.py](./documentdb_index_tool.py)
  
- Restore mongo collection dump to documentdb via `mongorestore` WITH `mongorestore -v –noIndexRestore` since they have already been added in the previous step

## Dump single collection from atlas

```bash
mongodump --uri mongodb+srv://username:password@wb-cmdt-stg-nest.zlvrc.mongodb.net/nuxeo --collection=audit --gzip --archive=nest.audit.archive

mongodump --uri mongodb+srv://username:password@wb-cmdt-prod-nest.zlvrc.mongodb.net/nuxeo --collection=audit --gzip --archive=nest.audit.archive
```

## Login for atlas

```bash
mongo "mongodb+srv://wb-cmdt-stg-nest.zlvrc.mongodb.net/nuxeo" --username admin

mongo "mongodb+srv://wb-cmdt-prod-nest.zlvrc.mongodb.net/nuxeo" --username admin
```

## Login for documentdb

```bash
wget https://s3.amazonaws.com/rds-downloads/rds-ca-2019-root.pem

# stg
mongo --ssl --host wb-cmdt-stg-nest.cluster-c6cxghxqhxpv.us-west-2.docdb.amazonaws.com:27017 --sslCAFile rds-ca-2019-root.pem  --username <username>

# prod
mongo --ssl --host wb-cmdt-prod-nest.cluster-c6cxghxqhxpv.us-west-2.docdb.amazonaws.com:27017 --sslCAFile rds-ca-2019-root.pem  --username <username>
```

## Restore

```bash
# stg
mongorestore -v --noIndexRestore --host wb-cmdt-stg-nest.cluster-c6cxghxqhxpv.us-west-2.docdb.amazonaws.com:27017 --numInsertionWorkersPerCollection 4 --ssl --sslCAFile rds-ca-2019-root.pem --username <username> --password 'password' --archive=./nest.audit.archive --gzip

# prod
mongorestore -v --noIndexRestore --host wb-cmdt-prod-nest.cluster-c6cxghxqhxpv.us-west-2.docdb.amazonaws.com:27017 --numInsertionWorkersPerCollection 4 --ssl --sslCAFile rds-ca-2019-root.pem --username <username> --password 'password' --archive=./nest.audit.archive --gzip
```

## S3 bucket for moving files

```bash
# The single collection dump
aws s3 cp nest.audit.archive s3://com-warnerbros-nuxeo-prod-mongo-backups/audit_collection/

aws s3 cp s3://com-warnerbros-nuxeo-prod-mongo-backups/audit_collection/nest.audit.archive .

# Index only dump
aws s3 cp prod_index_dump.zip s3://com-warnerbros-nuxeo-prod-mongo-backups/

aws s3 cp s3://com-warnerbros-nuxeo-prod-mongo-backups/prod_index_dump.zip .

unzip prod_index_dump.zip
```

## Install documentdb index tool for index creation

```bash
# We modified the online script to support mongo atlas
# Copy documentdb_index_tool.py and the requirements.txt
# To where ever you run the dump and restore and install the deps
pip3 install -r requirements.txt
```

## Index import and restore

```bash
# Dump the indexes from prod
python documentdb_index_tool.py --dump-indexes --atlas-connection "mongodb+srv://xxxx:xxxxx@wb-cmdt-prod-nest.zlvrc.mongodb.net/nuxeo?retryWrites=true&w=majority" --dir index_dump

# Check for any index issues
python documentdb_index_tool.py --show-issues --dir index_dump

# Restore Atlas index to DocumentDB, skip incompatible ones for now
python documentdb_index_tool.py --restore-indexes --skip-incompatible --host "wb-cmdt-stg-nest.cluster-c6cxghxqhxpv.us-west-2.docdb.amazonaws.com" --port 27017 --username <username> --password 'xxxxx' --auth-db admin --dir index_dump --tls --tls-ca-file rds-ca-2019-root.pem
```

## Install mongo cli on ubuntu 20

```bash
wget -qO - <https://www.mongodb.org/static/pgp/server-4.4.asc> | sudo apt-key add -

echo "deb [ arch=amd64,arm64 ] <https://repo.mongodb.org/apt/ubuntu> focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

apt-get update

apt-get install -y mongodb-org
```

## Errors

Might encounter this error. If so you can ignore IF all the indexes are verified to have been created correctly

```bash
pymongo.errors.OperationFailure: system collection creation not supported, full error: {'ok': 0.0, 'operationTime': Timestamp(1614193779, 1), 'code': 73, 'errmsg': 'system collection creation not supported'}
```

```bash
# Verify indexes exist after creation
rs0:PRIMARY> db.<collection-name>.getIndexes();
```
