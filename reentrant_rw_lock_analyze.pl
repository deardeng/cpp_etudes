
perl -ne 'if (/(\w+)\(\):(\d+)/) { $count{$1}{$2}++ } END { foreach $key1 (sort keys %count) { print "$key1 : "; foreach $key2 (sort keys %{$count{$key1}}) { print "$key2\($count{$key1}{$key2})_"; } print "\n"; } }' dx_test.txt

可重入rwlock，比如dx_test.txt中getUserByUserIdentity, 死锁了rlock后继续rlock，还能完成
所以脚本跑出结果如下，看不出卡在哪里了，堆栈打印出也同样看不出，但是能看到clearEntriesSetByResolver 和 userIdentityExist 在等锁，很坑爹啊！！！
唯一能怀疑的就是getUserByUserIdentity，只调用了1次，而问题确实是这个函数中rlock.lock -> rlock.lock
堆栈如582988.txt

addUserPrivEntriesByResolvedIPs : 379(185)_381(185)_405(185)_
checkPasswordInternal : 125(4815)_127(4815)_136(4815)_
clearEntriesSetByResolver : 213(186)_215(185)_235(185)_
createUser : 241(60)_243(60)_248(60)_
getAllDomains : 358(186)_360(186)_370(186)_
getNameToUsers : 335(29)_337(29)_342(29)_
getUserByName : 101(6)_107(6)_99(6)_
getUserByUserIdentity : 285(1)_287(1)_303(1)_
getUserId : 479(15)_481(15)_497(15)_
removeClusterPrefix : 445(19)_447(19)_456(19)_
removeUser : 308(6)_310(6)_330(6)_
userIdentityExist : 72(143)_74(142)_79(142)_

pr: https://github.com/apache/doris/pull/34699