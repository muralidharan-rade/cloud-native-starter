#!/bin/bash

root_folder=$(cd $(dirname $0); cd ..; pwd)

exec 3>&1

function _out() {
  echo "$(date +'%F %H:%M:%S') $@"
}

function setup() {
  _out Deploying articles-java-jee-v1
  
  cd ${root_folder}/articles-java-jee-v1
  kubectl delete -f deployment/kubernetes.yaml
  kubectl delete -f deployment/istio.yaml

  mvn package
  docker build -t articles:1 .

  kubectl apply -f deployment/kubernetes.yaml
  kubectl apply -f deployment/istio.yaml

  _out Minikube IP: $(minikube ip)
  _out NodePort: $(kubectl get svc articles --output 'jsonpath={.spec.ports[*].nodePort}')
  
  _out Done deploying articles-java-jee-v1
}

setup