#!/bin/bash

kubectl delete deploy recommendation-delay-v2 recommendation-v2
istioctl delete virtualservice recommendation