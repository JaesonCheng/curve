#
#  Copyright (c) 2020 NetEase Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

#!/bin/sh

home=deploy/local/chunkserver
loghome=log
#home=.
conf=${home}/conf
bin=bazel-bin/src/chunkserver
curveformt=bazel-bin/src/tools
#bin=.

[ -f ${loghome} ] || mkdir -p ${loghome}
[ -f ${loghome}/0 ] || mkdir -p ${loghome}/0
[ -f ${loghome}/1 ] || mkdir -p ${loghome}/1
[ -f ${loghome}/2 ] || mkdir -p ${loghome}/2

${curveformt}/curve_format -chunkfilepool_dir=./0/chunkfilepool/ -chunkfilepool_metapath=./0/chunkfilepool.meta -filesystem_path=./0/ -allocateByPercent=false -preallocateNum=16
${curveformt}/curve_format -chunkfilepool_dir=./1/chunkfilepool/ -chunkfilepool_metapath=./1/chunkfilepool.meta -filesystem_path=./1/ -allocateByPercent=false -preallocateNum=16
${curveformt}/curve_format -chunkfilepool_dir=./2/chunkfilepool/ -chunkfilepool_metapath=./2/chunkfilepool.meta -filesystem_path=./2/ -allocateByPercent=false -preallocateNum=16

${bin}/chunkserver -bthread_concurrency=18 -raft_max_segment_size=8388608 -raft_max_install_snapshot_tasks_num=5 -raft_sync=true -chunkServerIp=127.0.0.1  -chunkServerPort=8200 -chunkServerStoreUri=local://./0/ -chunkServerMetaUri=local://./0/chunkserver.dat -copySetUri=local://./0/copysets -raftSnapshotUri=curve://./0/copysets  -recycleUri=local://./0/recycler -chunkFilePoolDir=./0/chunkfilepool/ -chunkFilePoolMetaPath=./0/chunkfilepool.meta -v 19 -conf=${conf}/chunkserver.conf.0 2>${loghome}/0/chunkserver.err &
${bin}/chunkserver -bthread_concurrency=18 -raft_max_segment_size=8388608 -raft_max_install_snapshot_tasks_num=5 -raft_sync=true -chunkServerIp=127.0.0.1  -chunkServerPort=8201 -chunkServerStoreUri=local://./1/ -chunkServerMetaUri=local://./1/chunkserver.dat -copySetUri=local://./1/copysets -raftSnapshotUri=curve://./1/copysets -recycleUri=local://./1/recycler -chunkFilePoolDir=./1/chunkfilepool/ -chunkFilePoolMetaPath=./1/chunkfilepool.meta -v 19 -conf=${conf}/chunkserver.conf.1 2>${loghome}/1/chunkserver.err &
${bin}/chunkserver -bthread_concurrency=18 -raft_max_segment_size=8388608 -raft_max_install_snapshot_tasks_num=5 -raft_sync=true -chunkServerIp=127.0.0.1  -chunkServerPort=8202 -chunkServerStoreUri=local://./2/ -chunkServerMetaUri=local://./2/chunkserver.dat -copySetUri=local://./2/copysets -raftSnapshotUri=curve://./2/copysets -recycleUri=local://./2/recycler -chunkFilePoolDir=./2/chunkfilepool/ -chunkFilePoolMetaPath=./2/chunkfilepool.meta -v 19 -conf=${conf}/chunkserver.conf.2 2>${loghome}/2/chunkserver.err &
