#!/bin/bash

# ansible releases built on a maintained ansible-core, see
# https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html
ANSIBLE_VERSIONS="12.3.0 13.8.0 14.5.0 15.0.0a2"

# ansible >= 15 (ansible-core >= 2.22) needs python >= 3.13 on the controller
function python_image()
{
	local ver=$1
	if [ ${ver%%.*} -ge 15 ]; then
		echo python:3.13.16-alpine3.23
	else
		echo python:3.12.15-alpine3.23
	fi
}

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
	echo docker build --network host --build-arg PYTHON_IMAGE=$(python_image ${version}) --build-arg REQUIREMENTS_FILE=requirements.${version}.txt -f Dockerfile -t osvccol:${version} .
	cmds ${version} /examples/inventory /examples/playbook-provision-cluster.yml
done

title "Building ansible upstream image"
echo docker build --network host -f Dockerfile.dev -t osvccol:dev .
cmds dev /examples/inventory /examples/playbook-provision-cluster.yml
