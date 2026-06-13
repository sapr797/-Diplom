#!/bin/bash

helm uninstall prometheus -n monitoring
kubectl delete namespace monitoring

echo "Prometheus + Grafana uninstalled"
