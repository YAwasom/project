#!/bin/bash

db_cluster_snapshot_identifier=$(aws rds describe-db-cluster-snapshots --filter Name=snapshot-type,Values=manual --query 'DBClusterSnapshots[*].[DBClusterSnapshotIdentifier]' --output text)

while read -r db_snap_id; do
    echo "Deleting snapshot: $db_snap_id"
    aws rds delete-db-cluster-snapshot \
    --db-cluster-snapshot-identifier $db_snap_id
done <<< "$db_cluster_snapshot_identifier"