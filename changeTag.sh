
#!/bin/bash
sed "s/tagVersion/$1/g" deployment.yaml > newapp-deployment.yaml
mv  newapp-deployment.yaml /manifests
