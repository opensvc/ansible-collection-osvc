# opensvc\.cluster\_v3 Release Notes

**Topics**

- <a href="#v1-3-1">v1\.3\.1</a>
    - <a href="#release-summary">Release Summary</a>
    - <a href="#bugfixes">Bugfixes</a>
- <a href="#v1-3-0">v1\.3\.0</a>
    - <a href="#release-summary-1">Release Summary</a>
    - <a href="#minor-changes">Minor Changes</a>
    - <a href="#bugfixes-1">Bugfixes</a>
- <a href="#v1-2-0">v1\.2\.0</a>
    - <a href="#breaking-changes--porting-guide">Breaking Changes / Porting Guide</a>
    - <a href="#bugfixes-2">Bugfixes</a>
- <a href="#v1-1-0">v1\.1\.0</a>
    - <a href="#minor-changes-1">Minor Changes</a>
    - <a href="#bugfixes-3">Bugfixes</a>
- <a href="#v1-0-0">v1\.0\.0</a>
    - <a href="#minor-changes-2">Minor Changes</a>
    - <a href="#bugfixes-4">Bugfixes</a>

<a id="v1-3-1"></a>
## v1\.3\.1

<a id="release-summary"></a>
### Release Summary

Bugfix release\: the roles no longer rely on the top\-level fact variables deprecated by ansible\-core 2\.20\, and the cluster vip interface detection matches the exact node name\.

<a id="bugfixes"></a>
### Bugfixes

* Use the <code>ansible\_facts</code> dictionary instead of the top\-level fact variables\, removing the <code>INJECT\_FACTS\_AS\_VARS</code> deprecation warning of ansible\-core 2\.20 and later\.
* provision\_cluster \- without <code>provision\_cluster\_vip\_dev</code>\, the vip interface detection picked the wrong ip when <code>/etc/hosts</code> listed a loopback address or an alias like <code>hb1\-\<hostname\></code> for the node name\, and found none when the node name preceded the fqdn\. The node production ip lookup now matches the exact node name and skips the loopback addresses\.

<a id="v1-3-0"></a>
## v1\.3\.0

<a id="release-summary-1"></a>
### Release Summary

install\_drbd now installs DRBD 9 when it is missing\, from the LINBIT ppa\, ELRepo or the official LINBIT repositories\. The roles use the current OpenSVC v3 commands\, and the waits on the node and vip states are fixed\.

<a id="minor-changes"></a>
### Minor Changes

* Documentation \- README\: describe the collection\, add the support and release notes sections\.
* Documentation \- README\: document the ansible\-core and managed nodes python compatibility\.
* Documentation \- install\_drbd\: document the DRBD 9 sources and variables\.
* Roles metadata \- declare the tested platforms\, EL 7 to 10 and Ubuntu 20\.04 to 26\.04\, instead of all the Fedora\, EL\, Debian and Ubuntu versions\.
* Use the current OpenSVC v3 commands instead of the deprecated or hidden aliases\: <code>om daemon events</code>\, <code>om daemon auth \-\-role join</code> \(join token valid 10 minutes instead of 1\)\, <code>om cluster config get</code> and <code>om cluster config update \-\-set</code>\, <code>unfreeze</code>\, <code>key add/decode/change \<key\></code>\, <code>om daemon hb list</code>\.
* install\_drbd \- install DRBD 9 when no drbd 9 module is installed\, from the LINBIT ppa on Ubuntu \>\= 22\.04\, or from ELRepo on RHEL 8\, 9 and 10\. The role only loaded an already installed module\.
* install\_drbd \- new <code>install\_drbd\_linbit\_key</code> variable\, the confidential LINBIT enabler code\: when set\, DRBD 9 is installed from the official LINBIT customer repositories \(Ubuntu\, Debian\, RHEL 7 to 10\)\. The tasks using it are hidden from the logs\, and the repository files are readable by root only\.
* provision\_cluster\, install\_dns \- the event filters select the nodes by hostname\, like the OpenSVC node names\.

<a id="bugfixes-1"></a>
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

<a id="bugfixes-2"></a>
### Bugfixes

* unprovision\_cluster \- fail when services or volumes are still defined on the cluster\.
* unprovision\_cluster \- remove opensvc\-client too\, drop the v2 daemon shutdown tasks\.
* unprovision\_services \- keep the objects the cluster needs\: cluster\, <code>system/sec/ca</code>\, <code>system/sec/cert</code>\, <code>system/sec/hb</code>\, <code>system/sec/relay</code>\, the secrets referenced by relay heartbeats\, and the users\. The hb secret was purged\, breaking the heartbeats at the next daemon restart\.
* unprovision\_services \- purge volumes after the services holding them\.
* unprovision\_services \- remove the <code>cluster\.vip</code> tasks\, deprecated in OpenSVC v3\.
* unprovision\_services \- thaw the cluster after the purge\, unless it was frozen before\.

<a id="v1-1-0"></a>
## v1\.1\.0

<a id="minor-changes-1"></a>
### Minor Changes

* New role install\_hb\_relay\, to add a relay heartbeat to the cluster\.
* install\_backend\_network \- <code>install\_backend\_network\_subnet\_ips\_per\_node</code> is replaced by <code>install\_backend\_network\_subnet\_mask\_per\_node</code> \(per\-node subnet prefix length\, default 24\)\.
* install\_pool \- <code>osvc\_pool\_path</code> is now <code>install\_pool\_path</code>\, <code>osvc\_pool\_vg</code> is now <code>install\_pool\_vg</code>\.
* install\_pool \- add <code>vg</code> pool type and <code>install\_pool\_force</code> to overwrite an existing pool\.
* provision\_cluster \- install a given OpenSVC version with <code>provision\_cluster\_version</code> \(server and client pinned\)\, downgrades require <code>provision\_cluster\_allow\_downgrade</code>\, freeze the cluster before and thaw it only once all nodes have rejoined\.
* provision\_cluster \- set the <code>hb\#1\.timeout</code> keyword from <code>provision\_cluster\_hb\_timeout</code>\.

<a id="bugfixes-3"></a>
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

<a id="minor-changes-2"></a>
### Minor Changes

* Red Hat Ansible Automation Platform is ending support for Ansible Core 2\.15 and Python 3\.11\.
* Set minimum ansible version to 2\.16\.0\.

<a id="bugfixes-4"></a>
### Bugfixes

* Fix deprecated syntax\.
* Fix linting and sanity errors\.
