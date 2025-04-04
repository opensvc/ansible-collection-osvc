#!/bin/bash

ANSIBLE_VERSIONS="8.0 9.0 10.0 11.1.0"

function title()
{
	local title="$@"
	echo
	echo "### ${title} ##"
}

function cmds()
{
	local ver=$1
	local inv=$2
	local play=$3
	echo docker run --rm -it osvccol:${ver} ansible --version \| grep "^ansible"
	echo docker run --rm -it osvccol:${ver} ansible-test-sanity
	echo docker run --rm -v $PWD/examples:/examples -it osvccol:${ver} check
	echo docker run --rm -v $PWD/examples:/examples -it osvccol:${ver} get-tarball
	echo docker run --rm -v $PWD/examples:/examples -it osvccol:${ver} ansible-playbook -i ${inv} ${play} 
}

for version in ${ANSIBLE_VERSIONS}
do
	cat requirements.template.txt | sed -e s@ANSIBLE_VERSION@${version}@ >| requirements.${version}.txt
	title "Building ansible ${version} image"
	echo docker build --network host --build-arg REQUIREMENTS_FILE=requirements.${version}.txt -f Dockerfile -t osvccol:${version} .
	cmds ${version} /examples/inventory /examples/playbook-provision-cluster.yml
done

title "Building ansible upstream image"
echo docker build --network host -f Dockerfile.dev -t osvccol:dev .
cmds dev /examples/inventory /examples/playbook-provision-cluster.yml
