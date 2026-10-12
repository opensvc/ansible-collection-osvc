# opensvc\.cluster Release Notes

**Topics**

- <a href="#v2-1-1">v2\.1\.1</a>
    - <a href="#release-summary">Release Summary</a>
    - <a href="#bugfixes">Bugfixes</a>
- <a href="#v2-1-0">v2\.1\.0</a>
    - <a href="#release-summary-1">Release Summary</a>
    - <a href="#minor-changes">Minor Changes</a>
    - <a href="#bugfixes-1">Bugfixes</a>
- <a href="#v2-0-0">v2\.0\.0</a>
    - <a href="#minor-changes-1">Minor Changes</a>
    - <a href="#breaking-changes--porting-guide">Breaking Changes / Porting Guide</a>
    - <a href="#bugfixes-2">Bugfixes</a>
- <a href="#v1-3-0">v1\.3\.0</a>
    - <a href="#minor-changes-2">Minor Changes</a>
    - <a href="#bugfixes-3">Bugfixes</a>
- <a href="#v1-2-1">v1\.2\.1</a>
    - <a href="#bugfixes-4">Bugfixes</a>
- <a href="#v1-2-0">v1\.2\.0</a>
    - <a href="#minor-changes-3">Minor Changes</a>
- <a href="#v1-1-1">v1\.1\.1</a>
    - <a href="#minor-changes-4">Minor Changes</a>
- <a href="#v1-1-0">v1\.1\.0</a>
    - <a href="#minor-changes-5">Minor Changes</a>

<a id="v2-1-1"></a>
## v2\.1\.1

<a id="release-summary"></a>
### Release Summary

Bugfix release\: the roles no longer rely on the top\-level fact variables deprecated by ansible\-core 2\.20\, and the cluster vip interface detection matches the exact node name\.

<a id="bugfixes"></a>
### Bugfixes

* Use the <code>ansible\_facts</code> dictionary instead of the top\-level fact variables\, removing the <code>INJECT\_FACTS\_AS\_VARS</code> deprecation warning of ansible\-core 2\.20 and later\.
* provision\_cluster \- the cluster vip was set up on the wrong interface when <code>/etc/hosts</code> listed an alias like <code>\<hostname\>\-hb1</code> before the node name\, or a loopback address for the node name\. The node production ip lookup now matches the exact node name and skips the loopback addresses\.

<a id="v2-1-0"></a>
## v2\.1\.0

<a id="release-summary-1"></a>
### Release Summary

Maintenance release\: RHEL 10 support in install\_drbd\, Ubuntu 26\.04 and RHEL 7 fixes\, no breaking change\. The collection is now licensed under Apache\-2\.0\, like its roles\.

<a id="minor-changes"></a>
### Minor Changes

* Documentation \- README\: describe the collection\, add the support and release notes sections\.
* Documentation \- README\: document the ansible\-core and managed nodes python compatibility\.
* License \- the collection is licensed under Apache\-2\.0\, like its roles \(galaxy\.yml declared GPL\-2\.0\-or\-later\)\, and ships the LICENSE file\.
* Roles metadata \- declare the tested platforms\, EL 7 to 10 and Ubuntu 20\.04 to 26\.04\, instead of all the Fedora\, EL\, Debian and Ubuntu versions\.
* install\_drbd \- declare the LINBIT ppa as a deb822 source when apt\-key is missing \(apt 3\, Ubuntu 26\.04\)\, <code>ansible\.builtin\.apt\_repository</code> can not fetch the ppa signing key without it\.
* install\_drbd \- support RHEL 10\, with the ELRepo packages\.

<a id="bugfixes-1"></a>
### Bugfixes

* examples \- use the role variable names introduced in 2\.0\.0\.
* galaxy\.yml \- remove the duplicate <code>dependencies</code> key\, <code>community\.general</code> is not a dependency since 1\.2\.0\.
* install\_drbd \- fail with an explicit message on EL7 when no drbd 9 module is installed\, ELRepo provides no drbd 9 packages for EL7 anymore\.
* install\_drbd \- keep an already installed drbd 9 module\, instead of installing the ELRepo packages conflicting with the LINBIT ones\.
* provision\_cluster \- install the EL7 packages with yum\, EL7 has no dnf\.
* provision\_cluster \- report the mutual root ssh trust as changed only when <code>authorized\_keys</code> changes\.
* roles tests \- call the roles by FQCN\, and the install\_pool test now runs install\_pool\.

<a id="v2-0-0"></a>
## v2\.0\.0

<a id="minor-changes-1"></a>
### Minor Changes

* Red Hat Ansible Automation Platform is ending support for Ansible Core 2\.15 and Python 3\.11\.
* Set minimum ansible version to 2\.16\.0\.

<a id="breaking-changes--porting-guide"></a>
### Breaking Changes / Porting Guide

* Role variable names now comply with Ansible linter\.

<a id="bugfixes-2"></a>
### Bugfixes

* Fix linting and sanity errors\.

<a id="v1-3-0"></a>
## v1\.3\.0

<a id="minor-changes-2"></a>
### Minor Changes

* Bump to Ansible Core 2\.16 and Python 3\.12 minimum version\.

<a id="bugfixes-3"></a>
### Bugfixes

* Fix /etc/hosts file build\.
* Fix variable definition\.

<a id="v1-2-1"></a>
## v1\.2\.1

<a id="bugfixes-4"></a>
### Bugfixes

* Fix command\-instead\-of\-shell warning during galaxy import\.

<a id="v1-2-0"></a>
## v1\.2\.0

<a id="minor-changes-3"></a>
### Minor Changes

* Remove community\.general dependency \(install\_drbd role impacted\)\.
* Set minimum ansible version to 2\.13\.0\.

<a id="v1-1-1"></a>
## v1\.1\.1

<a id="minor-changes-4"></a>
### Minor Changes

* Add mandatory tags in opensvc\.cluster collection\.

<a id="v1-1-0"></a>
## v1\.1\.0

<a id="minor-changes-5"></a>
### Minor Changes

* Implement changes requested by Red Hat Ansible partners team\.
