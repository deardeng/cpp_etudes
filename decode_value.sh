token=greedisgood9999
key_info="key_type=InstanceKey&instance_id=gavin-instance"
key_info="key_type=TxnLabelKey&instance_id=gavin-instance&db_id=10086&label=test-label"
key_info="key_type=TxnInfoKey&instance_id=gavin-instance&db_id=10086&txn_id=10010"
key_info="key_type=TxnIndexKey&instance_id=gavin-instance&txn_id=10086"
key_info="key_type=TxnRunningKey&instance_id=gavin-instance&db_id=10086&txn_id=10010"
key_info="key_type=VersionKey&instance_id=gavin-instance&db_id=10086&tbl_id=10010&partition_id=10000"
key_info="key_type=MetaRowsetKey&instance_id=gavin-instance&tablet_id=10086&version=10010"
key_info="key_type=MetaRowsetTmpKey&instance_id=gavin-instance&txn_id=10086&tablet_id=10010"
key_info="key_type=MetaTabletKey&instance_id=gavin-instance&table_id=10086&index_id=100010&part_id=10000&tablet_id=1008601"
key_info="key_type=MetaTabletIdxKey&instance_id=gavin-instance&tablet_id=10086"
key_info="key_type=RecycleIndexKey&instance_id=gavin-instance&index_id=10086"
key_info="key_type=RecyclePartKey&instance_id=gavin-instance&part_id=10086"
key_info="key_type=RecycleRowsetKey&instance_id=gavin-instance&tablet_id=10086&rowset_id=10010"
key_info="key_type=RecycleTxnKey&instance_id=gavin-instance&db_id=10086&txn_id=10010"
key_info="key_type=StatsTabletKey&instance_id=gavin-instance&table_id=10086&index_id=10010&part_id=10000&tablet_id=1008601"
key_info="key_type=JobTabletKey&instance_id=gavin-instance&table_id=10086&index_id=10010&part_id=10000&tablet_id=1008601"
key_info="key_type=CopyJobKey&instance_id=gavin-instance&stage_id=10086&table_id=10010&copy_id=10000&group_id=1008601"
key_info="key_type=CopyFileKey&instance_id=gavin-instance&stage_id=10086&table_id=10010&obj_key=10000&obj_etag=1008601"
key_info="key_type=RecycleStageKey&instance_id=gavin-instance&stage_id=10086"
key_info="key_type=JobRecycleKey&instance_id=gavin-instance"
key_info="key_type=MetaSchemaKey&instance_id=gavin-instance&index_id=10086&schema_version=10010"
key_info="key_type=MetaDeleteBitmap&instance_id=gavin-instance&tablet_id=10086&rowest_id=10010&version=10000&seg_id=1008601"
key_info="key_type=MetaDeleteBitmapUpdateLock&instance_id=gavin-instance&table_id=10086&partition_id=10010"
key_info="key_type=MetaPendingDeleteBitmap&instance_id=gavin-instance&tablet_id=10086"
key_info="key_type=RLJobProgressKey&instance_id=gavin-instance&db_id=10086&job_id=10010"
key_info="key_type=MetaServiceRegistryKey"
key_info="key_type=MetaServiceArnInfoKey"
key_info="key_type=MetaServiceEncryptionKey"



key_info="key_type=InstanceKey&instance_id=selectdb-cn-36z3o9vwt01"

token=c49e0qqnf7f1v00p
token='greedisgood9999'
set -x
# curl "175.40.101.1:5000/MetaService/http/get_value?token=${token}&unicode&${key_info}"
key_info="key_type=InstanceKey&instance_id=selectdb-cn-x0r3mc2v001"
key_info="key_type=MetaRowsetKey&instance_id=default_instance_id&tablet_id=27700&version=3"
key_info="key_type=MetaTabletKey&instance_id=selectdb-cn-fsw49q4u201&table_id=1749293954671&index_id=1749293954672&part_id=1749293954670&tablet_id=1749293954737"
key_info="key_type=StatsTabletKey&instance_id=default_instance_id&table_id=1750142510926&index_id=1750142510927&part_id=1750142510925&tablet_id=1750142510930;"
key_info="key_type=MetaRowsetKey&instance_id=default_instance_id&tablet_id=1750142510930&version=2"
curl "175.43.101.1:5000/MetaService/http/get_value?token=${token}&unicode&${key_info}"
