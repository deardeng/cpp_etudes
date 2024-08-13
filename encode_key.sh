key_info="key_type=RecycleRowsetKey&instance_id=AWVAPO4Z&tablet_id=304156100&rowset_id=A"
key_info="key_type=StatsTabletKey&instance_id=AWVAPO4Z&table_id=23514358&part_id=229940573&index_id=23514359&tablet_id=229997476"
key_info="key_type=MetaRowsetKey&instance_id=gavin-instance&tablet_id=10086&version=10010&unicode=false"
key_info="key_type=VersionKey&instance_id=lw_instance_0&db_id=10013&tbl_id=37468&partition_id=39556"
key_info="key_type=MetaSchemaKey&instance_id=selectdb-cloud-dev-asan&index_id=24933967&schema_version=0"

key_info="key_type=MetaRowsetKey&instance_id=ALFFU6Q6&tablet_id=705368177&version=25634"
key_info="key_type=MetaRowsetKey&instance_id=ALFFU6Q6&tablet_id=692128869&version=25414"
key_info="key_type=MetaRowsetKey&instance_id=ALFFU6Q6&tablet_id=692128875&version=25414"
key_info="key_type=InstanceKey&instance_id=ALBJREQ1"
key_info="key_type=TxnLabelKey&instance_id=gavin-instance&db_id=10086&label=test-label"
key_info="key_type=MetaTabletIdxKey&instance_id=selectdb_cloud_compatibility_asan&tablet_id=971194"
key_info="key_type=InstanceKey&instance_id=0"
key_info="key_type=MetaServiceRegistryKey"
key_info="key_type=RecycleIndexKey&instance_id=Instance0&index_id=12673"
key_info="key_type=MetaRowsetKey&instance_id=Instance0&tablet_id=1222917&version=26"
key_info="key_type=MetaRowsetKey&instance_id=ALHZC457&tablet_id=130448163&version=4112"
key_info="key_type=MetaTabletKey&instance_id=AZAZQPWO&table_id=3317275273545&index_id=3317275273546&part_id=3317275273541&tablet_id=5747543"


# key_info="key_type=InstanceKey&instance_id=ALBJREQ1"
# key_info="key_type=TxnLabelKey&instance_id=gavin-instance&db_id=10086&label=test-label"
# key_info="key_type=TxnInfoKey&instance_id=gavin-instance&db_id=10086&txn_id=10010"
# key_info="key_type=TxnIndexKey&instance_id=gavin-instance&txn_id=10086"
# key_info="key_type=TxnRunningKey&instance_id=gavin-instance&db_id=10086&txn_id=10010"
# key_info="key_type=VersionKey&instance_id=gavin-instance&db_id=10086&tbl_id=10010&partition_id=10000"
# key_info="key_type=MetaRowsetKey&instance_id=gavin-instance&tablet_id=10086&version=10010"
# key_info="key_type=MetaRowsetTmpKey&instance_id=gavin-instance&txn_id=10086&tablet_id=10010"
# key_info="key_type=MetaTabletKey&instance_id=gavin-instance&table_id=10086&index_id=100010&part_id=10000&tablet_id=1008601"
# key_info="key_type=MetaTabletIdxKey&instance_id=gavin-instance&tablet_id=10086"
# key_info="key_type=RecycleIndexKey&instance_id=gavin-instance&index_id=10086"
# key_info="key_type=RecyclePartKey&instance_id=gavin-instance&part_id=10086"
# key_info="key_type=RecycleRowsetKey&instance_id=gavin-instance&tablet_id=10086&rowset_id=10010"
# key_info="key_type=RecycleTxnKey&instance_id=gavin-instance&db_id=10086&txn_id=10010"
# key_info="key_type=StatsTabletKey&instance_id=gavin-instance&table_id=10086&index_id=10010&part_id=10000&tablet_id=1008601"
# key_info="key_type=JobTabletKey&instance_id=gavin-instance&table_id=10086&index_id=10010&part_id=10000&tablet_id=1008601"
# key_info="key_type=CopyJobKey&instance_id=gavin-instance&stage_id=10086&table_id=10010&copy_id=10000&group_id=1008601"
# key_info="key_type=CopyFileKey&instance_id=gavin-instance&stage_id=10086&table_id=10010&obj_key=10000&obj_etag=1008601"
# key_info="key_type=RecycleStageKey&instance_id=gavin-instance&stage_id=10086"
# key_info="key_type=JobRecycleKey&instance_id=gavin-instance"
# key_info="key_type=MetaSchemaKey&instance_id=gavin-instance&index_id=10086&schema_version=10010"
# key_info="key_type=MetaDeleteBitmap&instance_id=gavin-instance&tablet_id=10086&rowest_id=10010&version=10000&seg_id=1008601"
# key_info="key_type=MetaDeleteBitmapUpdateLock&instance_id=gavin-instance&table_id=10086&partition_id=10010"
# key_info="key_type=MetaPendingDeleteBitmap&instance_id=gavin-instance&tablet_id=10086"
# key_info="key_type=RLJobProgressKey&instance_id=gavin-instance&db_id=10086&job_id=10010"
# key_info="key_type=MetaServiceRegistryKey"
# key_info="key_type=MetaServiceArnInfoKey"
# key_info="key_type=MetaServiceEncryptionKey"

if [ "$1" != "" ]; then
  key_info=$1
fi

set -x
curl "localhost:5000/MetaService/http/encode_key?token=greedisgood9999&unicode&${key_info}"
set +x

# vim: tw=10086 et:
