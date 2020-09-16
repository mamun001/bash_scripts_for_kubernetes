#!/bin/bash


echo "#############################################################################"
echo
echo lost of available contexts
echo
kubectl config get-contexts
echo

echo "#############################################################################"
echo 
echo -n "ENTER CONTEXT: "
read CONTEXT
echo
if [[ -z "$CONTEXT" ]]; then
   echo Context cannot be empty
   echo exiting
   exit 0
fi


kubectl config use-context $CONTEXT


echo "#############################################################################"
echo
echo list of namespace and pods:
echo
#kubectl get pods -A | grep ^arcules | awk  '{print $2}' | sort
#kubectl get pods -A  | awk  '{print $1,$2}' | sort
kubectl get pods -A | grep -v dyna | grep -v kube-sys | grep -v weave  | awk  '{print $1,$2}' | sort
echo
echo

echo "#############################################################################"
echo
echo -n "ENTER KEYWORD to search in list of pods: "
read KW
echo searching ...
echo
echo NAMESPACE:POD
kubectl get pods -A  | awk  '{print $1,$2}' | grep $KW | sort
echo
echo

echo "#############################################################################"
echo 
echo -n "ENTER POD NAME: "
read POD
echo POD=$POD
echo

echo "#############################################################################"
echo 
echo Finding namesapce
echo
NAMESPACE=`kubectl get pods -A | grep $POD | awk '{ print $1 }'`
echo 
echo NAMESPACE=$NAMESPACE
echo




echo "#############################################################################"
echo 
echo Finding out how many containers this pod has:
echo
COUNT=`kubectl get pods -A | grep $POD |  awk  '{print $3}'`
echo $COUNT
if [ "$COUNT" == "1/1" ] ; then
  echo has 1 running container
  sleep 1
  #kubectl logs --follow $POD --namespace=production
  kubectl logs --follow $POD --namespace=$NAMESPACE
elif [ "$COUNT" == "2/2" ] ; then
  echo
  echo has 2 running containers
  echo so you have to use minus c
  echo
else
  echo $COUNT
  echo 3rd case
  echo
  sleep 2
  #kubectl logs --follow $POD --namespace=production
  kubectl logs --follow $POD --namespace=$NAMESPACE
fi


