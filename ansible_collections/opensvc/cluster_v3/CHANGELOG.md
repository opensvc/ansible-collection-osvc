# opensvc\.cluster\_v3 Release Notes

**Topics**

- <a href="#v1-5-0">v1\.5\.0</a>
    - <a href="#release-summary">Release Summary</a>
    - <a href="#minor-changes">Minor Changes</a>
- <a href="#v1-4-0">v1\.4\.0</a>
    - <a href="#release-summary-1">Release Summary</a>
    - <a href="#minor-changes-1">Minor Changes</a>
    - <a href="#bugfixes">Bugfixes</a>
- <a href="#v1-3-1">v1\.3\.1</a>
    - <a href="#release-summary-2">Release Summary</a>
    - <a href="#bugfixes-1">Bugfixes</a>
- <a href="#v1-3-0">v1\.3\.0</a>
    - <a href="#release-summary-3">Release Summary</a>
    - <a href="#minor-changes-2">Minor Changes</a>
    - <a href="#bugfixes-2">Bugfixes</a>
- <a href="#v1-2-0">v1\.2\.0</a>
    - <a href="#breaking-changes--porting-guide">Breaking Changes / Porting Guide</a>
    - <a href="#bugfixes-3">Bugfixes</a>
- <a href="#v1-1-0">v1\.1\.0</a>
    - <a href="#minor-changes-3">Minor Changes</a>
    - <a href="#bugfixes-4">Bugfixes</a>
- <a href="#v1-0-0">v1\.0\.0</a>
    - <a href="#minor-changes-4">Minor Changes</a>
    - <a href="#bugfixes-5">Bugfixes</a>

<a id="v1-5-0"></a>
## v1\.5\.0

<a id="release-summary"></a>
### Release Summary

New role install\_hb\_multicast\. The README follows the certified collection README template\, with an Installation section focused on Red Hat Ansible Automation Hub and a License information section\.

<a id="minor-changes"></a>
### Minor Changes

* README \- add the Installation section\, focused on Red Hat Ansible Automation Hub\, and the License information section\, linking to the LICENSE file\. Also add the Description\, Requirements\, Use cases\, Testing\, Related information sections\, and a link to the platform life cycle\.
* install\_hb\_multicast \- new role\, adding a multicast heartbeat to the cluster\, with an optional interface per node\. It refuses a group and port pair already used by another multicast heartbeat\, and waits for the heartbeat to beat on every node\.

<a id="v1-4-0"></a>
## v1\.4\.0

<a id="release-summary-1"></a>
### Release Summary

Support of RHEL 8\, 9 and 10\, Ubuntu 22\.04\, 24\.04 and 26\.04\, SLES 15 and 16\, and Debian 12 and 13\, with ansible\.builtin modules only\. New roles install\_quorum\, install\_hb\_unicast and install\_hb\_disk\. The roles are idempotent\, and many fixes\, of the sshd root login setting\, the ELRepo key check\, the Debian repository signature\, the join and dns waits\, and the relay heartbeat wait among them\.

<a id="minor-changes-1"></a>
### Minor Changes

* all roles \- removed the <code>\.travis\.yml</code> and <code>tests/</code> skeletons of the roles\, and the unused handlers and <code>install\_drbd\_debian\_repo</code>\, <code>install\_drbd\_debian\_version</code> variables of install\_drbd\.
* install\_cni \- the flannel plugin is no longer required\.
* install\_cni \- use the CNI plugins already present on the nodes\, like the ones of the containernetworking\-plugins packages \(<code>/usr/lib/cni</code>\, <code>/usr/libexec/cni</code>\)\, instead of downloading them\. The new <code>install\_cni\_force</code> variable downloads them anyway\, and the new <code>install\_cni\_search\_dirs</code> variable lists the directories looked up\.
* install\_drbd \- set <code>use\_devicesfile \= 0</code> in <code>/etc/lvm/lvm\.conf</code>\, as OpenSVC nodes do not use the LVM devices file\, enabled by default on recent RHEL and SLES\, which ignores the drbd devices filter\.
* install\_drbd \- support SLES 15 and 16\, from the LINBIT repositories when <code>install\_drbd\_linbit\_key</code> is set\, else from the enabled repositories \(SLE High Availability extension\)\.
* install\_hb\_disk \- new role\, adding a disk heartbeat\. The disk is checked on every node\, signed once when it is not signed yet\, and a disk holding data or a known signature is refused unless forced\.
* install\_hb\_unicast \- new role\, adding a unicast heartbeat with the address\, and optionally the interface\, of each node\. A port already used by another unicast heartbeat of the cluster is refused\.
* install\_pool \- new <code>install\_pool\_keywords</code> variable\, a dictionary of other pool keywords\, like <code>quota</code>\, <code>thin\_pool</code> or <code>fs\_type</code>\.
* install\_pool \- update the keywords of an existing pool whose value differs from the role variables\, instead of leaving it as is unless <code>install\_pool\_force</code> is set\, which now sets all the keywords\. Configure loop\, shm\, virtual and zpool pools too\, refuse the other types\, and check the mandatory keywords of the vg\, zpool and virtual pools\.
* install\_quorum \- new role\, configuring the cluster quorum\, the arbitrators and\, optionally\, the split action\. The arbitrators must be seen up from every node before the quorum is enabled\. With an even number of nodes\, a setup losing a split in two equal parts is refused\, with no arbitrator\, or with several arbitrators of which the loss of one loses it\.
* provision\_cluster \- select the tasks and the repository by OS family\.
* provision\_cluster \- set the sysrq trigger with ansible\.builtin modules\, the collection no longer depends on ansible\.posix\.
* provision\_cluster \- support Debian 12 and 13\, with the Ubuntu tasks\.
* provision\_cluster \- support SLES 15 and 16\, from the <code>\<env\>\-opensvc\-v3\-sles15</code> and <code>\<env\>\-opensvc\-v3\-sles16</code> repositories\. ansible\.builtin has no zypper module\, so the repository is a <code>/etc/zypp/repos\.d/opensvc\.repo</code> file and the packages are installed with the <code>zypper</code> command\.
* provision\_cluster \- the <code>provision\_cluster\_opensvc\_command\_delay</code> variable is removed\, it was the sleep after each node join\. The role now waits for the joined node monitor to be idle\.
* unprovision\_cluster \- remove the OpenSVC packages on SLES\.
* unprovision\_cluster \- with <code>unprovision\_cluster\_purge</code>\, also remove the files added by provision\_cluster\, the OpenSVC package repository\, the sysrq setting\, the <code>/etc/hosts</code> block and the docker daemon configuration it installed\.

<a id="bugfixes"></a>
### Bugfixes

* install\_cni \- the <code>cni\.plugins</code> and <code>cni\.config</code> cluster keywords were not set when the plugins were already in <code>install\_cni\_plugins\_dir</code>\, and an interrupted download or extraction was never resumed\.
* install\_dns \- <code>install\_dns\_use\_ip\_from\_ansible\_host</code> failed with an <code>extract\(\)</code> error\, and now uses the <code>ansible\_host</code> variable\.
* install\_dns \- an empty <code>install\_dns\_cfg\_recursor\_allowed\_subnets</code> added a trailing comma to the recursor <code>allow\-from</code> setting\.
* install\_dns \- the <code>cluster\.dns</code> keyword of each node was set from the node itself\, one node at a time with a 5 seconds sleep between them\, to avoid concurrent cluster configuration updates\. All the nodes keywords are now set in one update from the first node\.
* install\_dns \- the debug tasks printed their message at the default verbosity\, they now need <code>\-vv</code>\.
* install\_dns \- the dns configmap existence check ignored <code>install\_dns\_cfgmap\_name</code>\.
* install\_dns \- the recursor configuration was edited in <code>/tmp/recursor</code>\, left on the first node\. It is now edited in a temporary file removed once the configmap key is set\, and <code>/tmp/recursor</code> is removed\.
* install\_drbd \- failed on the nodes with a DRBD 9 built from the sources\, which installs no <code>drbd\.service</code> systemd unit\.
* install\_drbd \- the DRBD version check read the module file on disk\, so a DRBD 8\.4 module loaded before the DRBD 9 installation was accepted\. The loaded module version is checked\, and a loaded DRBD 8\.4 module is replaced when not in use\.
* install\_drbd \- the ELRepo release package was installed without checking its signature\. The ELRepo signing key is now imported\, checked by its fingerprint \(<code>install\_drbd\_elrepo\_keys</code>\)\.
* install\_drbd \- the drbd devices rejection was added as a second <code>filter</code> line when <code>/etc/lvm/lvm\.conf</code> already had an active filter\. It is now prepended to the active filter\.
* install\_hb\_relay \- the wait for the heartbeat to beat read the output of om daemon hb list without its items list\, and never succeeded on a cluster of several nodes\.
* install\_pool\, install\_backend\_network \- the existence check did not parse the current <code>om pool ls</code> and <code>om net ls</code> json output\, so the pool and the network were configured again on each run\.
* provision\_cluster \- a node whose name is a prefix of a cluster node name\, like <code>node1</code> and <code>node10</code>\, was considered as already joined\, and a node whose inventory name is not its hostname was joined again on each run\. The joined nodes are now compared by hostname\.
* provision\_cluster \- each run on several nodes unfroze all the frozen nodes\, including the ones frozen by an operator\. Only the nodes frozen by the role for a downgrade are unfrozen now\.
* provision\_cluster \- the Debian repository was declared unsigned\, with <code>\[trusted\=yes\]</code>\. It is now checked with the OpenSVC signing key\, like the Ubuntu one\, and the unsigned declaration is removed\.
* provision\_cluster \- the git hash was not removed from the versions before comparing them\, so two builds of the same release could be detected as a downgrade\, and refused unless <code>provision\_cluster\_allow\_downgrade</code> was set\.
* provision\_cluster \- the repository url was empty and the install tasks file missing on SLES\.
* provision\_cluster \- with <code>provision\_cluster\_configure\_ssh\_trust</code>\, the root login setting was only changed in <code>/etc/ssh/sshd\_config</code>\, while the <code>sshd\_config\.d</code> files it includes take precedence\, like the <code>01\-permitrootlogin\.conf</code> file of RHEL 9 and 10 allowing the root login with a password\. It is now set in <code>sshd\_config\.d/00\-opensvc\.conf</code> too\, the files are validated with <code>sshd \-t</code>\, <code>PermitRootLogin no</code> is replaced too\, and the effective setting is checked\.
* provision\_cluster \- with <code>provision\_cluster\_configure\_ssh\_trust</code>\, the root login was left allowed with a password on RHEL 7\, whose sshd has no <code>Include</code> and allows it by default\. <code>PermitRootLogin prohibit\-password</code> is now added at the top of <code>/etc/ssh/sshd\_config</code> when it neither includes <code>sshd\_config\.d</code> nor sets it\.
* unprovision\_cluster \- the defined services were not checked when no daemon was running\. They are now looked up in the object configuration files\.

<a id="v1-3-1"></a>
## v1\.3\.1

<a id="release-summary-2"></a>
### Release Summary

Bugfix release\: the roles no longer rely on the top\-level fact variables deprecated by ansible\-core 2\.20\, and the cluster vip interface detection matches the exact node name\.

<a id="bugfixes-1"></a>
### Bugfixes

* Use the <code>ansible\_facts</code> dictionary instead of the top\-level fact variables\, removing the <code>INJECT\_FACTS\_AS\_VARS</code> deprecation warning of ansible\-core 2\.20 and later\.
* provision\_cluster \- without <code>provision\_cluster\_vip\_dev</code>\, the vip interface detection picked the wrong ip when <code>/etc/hosts</code> listed a loopback address or an alias like <code>hb1\-\<hostname\></code> for the node name\, and found none when the node name preceded the fqdn\. The node production ip lookup now matches the exact node name and skips the loopback addresses\.

<a id="v1-3-0"></a>
## v1\.3\.0

<a id="release-summary-3"></a>
### Release Summary

install\_drbd now installs DRBD 9 when it is missing\, from the LINBIT ppa\, ELRepo or the official LINBIT repositories\. The roles use the current OpenSVC v3 commands\, and the waits on the node and vip states are fixed\.

<a id="minor-changes-2"></a>
### Minor Changes

* Documentation \- README\: describe the collection\, add the support and release notes sections\.
* Documentation \- README\: document the ansible\-core and managed nodes python compatibility\.
* Documentation \- install\_drbd\: document the DRBD 9 sources and variables\.
* Roles metadata \- declare the tested platforms\, EL 7 to 10 and Ubuntu 20\.04 to 26\.04\, instead of all the Fedora\, EL\, Debian and Ubuntu versions\.
* Use the current OpenSVC v3 commands instead of the deprecated or hidden aliases\: <code>om daemon events</code>\, <code>om daemon auth \-\-role join</code> \(join token valid 10 minutes instead of 1\)\, <code>om cluster config get</code> and <code>om cluster config update \-\-set</code>\, <code>unfreeze</code>\, <code>key add/decode/change \<key\></code>\, <code>om daemon hb list</code>\.
* install\_drbd \- install DRBD 9 when no drbd 9 module is installed\, from the LINBIT ppa on Ubuntu \>\= 22\.04\, or from ELRepo on RHEL 8\, 9 and 10\. The role only loaded an already installed module\.
* install\_drbd \- new <code>install\_drbd\_linbit\_key</code> variable\, the confidential LINBIT enabler code\: when set\, DRBD 9 is installed from the official LINBIT customer repositories \(Ubuntu\, Debian\, RHEL 7 to 10\)\. The tasks using it are hidden from the logs\, and the repository files are readable by root only\.
* provision\_cluster\, install\_dns \- the event filters select the nodes by hostname\, like the OpenSVC node names\.

<a id="bugfixes-2"></a>
### Bugfixes

* install\_drbd \- the daemon restart handler used the OpenSVC v2 <code>om node wait</code> command\.
* install\_hb\_relay \- do not wait for the relay heartbeat to beat on a single node cluster\, which never reports it beating\.
* provision\_cluster \- ignore the play hosts without <code>provision\_cluster\_downgrade</code> when detecting a downgrade in the cluster\.
* provision\_cluster \- the waits for the node monitor idle state and for the vip instance up state did not wait\: their event filter data assertions lacked the leading dot\.
* roles tests \- call the roles by FQCN\, and the install\_pool test now runs install\_pool\.

<a id="v1-2-0"></a>
## v1\.2\.0

<a id="breaking-changes--porting-guide"></a>
### Breaking Changes / Porting Guide

* unprovision\_cluster \- the OpenSVC configuration and data are kept\, unless <code>unprovision\_cluster\_purge</code> is set to <code>true</code>\.
* unprovision\_services \- the role lists the objects to purge and fails without changing anything\, unless <code>unprovision\_services\_confirm</code> is set to <code>true</code>\.

<a id="bugfixes-3"></a>
### Bugfixes

* unprovision\_cluster \- fail when services or volumes are still defined on the cluster\.
* unprovision\_cluster \- remove opensvc\-client too\, drop the v2 daemon shutdown tasks\.
* unprovision\_services \- keep the objects the cluster needs\: cluster\, <code>system/sec/ca</code>\, <code>system/sec/cert</code>\, <code>system/sec/hb</code>\, <code>system/sec/relay</code>\, the secrets referenced by relay heartbeats\, and the users\. The hb secret was purged\, breaking the heartbeats at the next daemon restart\.
* unprovision\_services \- purge volumes after the services holding them\.
* unprovision\_services \- remove the <code>cluster\.vip</code> tasks\, deprecated in OpenSVC v3\.
* unprovision\_services \- thaw the cluster after the purge\, unless it was frozen before\.

<a id="v1-1-0"></a>
## v1\.1\.0

<a id="minor-changes-3"></a>
### Minor Changes

* New role install\_hb\_relay\, to add a relay heartbeat to the cluster\.
* install\_backend\_network \- <code>install\_backend\_network\_subnet\_ips\_per\_node</code> is replaced by <code>install\_backend\_network\_subnet\_mask\_per\_node</code> \(per\-node subnet prefix length\, default 24\)\.
* install\_pool \- <code>osvc\_pool\_path</code> is now <code>install\_pool\_path</code>\, <code>osvc\_pool\_vg</code> is now <code>install\_pool\_vg</code>\.
* install\_pool \- add <code>vg</code> pool type and <code>install\_pool\_force</code> to overwrite an existing pool\.
* provision\_cluster \- install a given OpenSVC version with <code>provision\_cluster\_version</code> \(server and client pinned\)\, downgrades require <code>provision\_cluster\_allow\_downgrade</code>\, freeze the cluster before and thaw it only once all nodes have rejoined\.
* provision\_cluster \- set the <code>hb\#1\.timeout</code> keyword from <code>provision\_cluster\_hb\_timeout</code>\.

<a id="bugfixes-4"></a>
### Bugfixes

* Install\_pool\, install\_backend\_network\: detect existing objects from <code>om \.\.\. ls \-o json</code>\.
* Provision\_cluster\, install\_drbd\: use the package module instead of dnf\, for RHEL 7 support\.
* RHEL 7 and RHEL 8 nodes need ansible\-core \<\= 2\.16 \(python 3\.6 targets\)\, see README\.
* Set <code>requires\_ansible</code> to <code>\>\=2\.16\.0</code>\, as required by Red Hat certification\.
* install\_dns \- prefix role variables with <code>install\_dns\_</code>\.
* install\_drbd \- detect a loaded module from /sys/module\, <code>lsmod \| grep \-q</code> under pipefail reported it as missing and reloaded it on every run\.
* install\_pool \- use <code>om cluster config update \-\-set</code>\.
* provision\_cluster \- compute the package repository path per distribution and release \(Debian repository path was missing the release codename\)\.
* provision\_cluster \- disable repository gpgcheck on RHEL 7\, as rpm 4\.11 can not verify subkey signatures\.
* provision\_cluster \- display the join token only with <code>\-vv</code>\.
* provision\_cluster \- install jq on Debian and Ubuntu\, remove python3\-netaddr\.
* provision\_cluster \- pass the join token through <code>OSVC\_JOIN\_TOKEN</code>\, <code>\-\-token</code> now expects a file path\.
* provision\_cluster \- ssh trust\, hb timeout\, cluster thaw and apt cache update no longer report a change on every run\.
* provision\_cluster \- use a deb822 signed repository on Ubuntu\.

<a id="v1-0-0"></a>
## v1\.0\.0

<a id="minor-changes-4"></a>
### Minor Changes

* Red Hat Ansible Automation Platform is ending support for Ansible Core 2\.15 and Python 3\.11\.
* Set minimum ansible version to 2\.16\.0\.

<a id="bugfixes-5"></a>
### Bugfixes

* Fix deprecated syntax\.
* Fix linting and sanity errors\.
