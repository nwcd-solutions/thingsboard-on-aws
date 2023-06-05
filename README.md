# thingsboard-on-aws

## 1. Deploy infrastructure
```
git clone https://github.com/nwcd-solutions/thingsboard-on-aws.git
cd thingsboard-on-aws/terraform
terraform init
```
```
terraform plan
```
```
terraform apply -auto-approve
```
In the previous step, we created the EKS cluster , and the module outputs the kubeconfig information which we can use to connect to the cluster.
The output configure_kubectl contains the command you can execute in your terminal to connect to the newly created cluster, example:
```
configure_kubectl = "aws eks --region us-east-2 update-kubeconfig --name eks-blueprint"
```

## 2. Installation
Execute the following command to run the initial setup of the database. This command will launch short-living ThingsBoard pod to provision necessary DB tables, indexes, etc

```
cd ../kubenetes
 ./k8s-install-tb.sh --loadDemo
```
Where:

    --loadDemo - optional argument. Whether to load additional demo data.

After this command finish you should see the next line in the console:
```
Installation finished successfully!
```
## 3.Starting

Execute the following command to deploy ThingsBoard services:
```
 ./k8s-deploy-resources.sh
```
After few minutes you may call kubectl get pods. If everything went fine, you should be able to see:

    5x tb-pe-js-executor
    2x tb-pe-web-ui
    1x tb-pe-node
    1x tb-pe-web-report
    3x zookeeper.
Every pod should be in the READY state.

You should also deploy the transport microservices. Omit the protocols that you don’t use in order to save resources:
### HTTP Transport (optional)
```
kubectl apply -f transports/tb-http-transport.yml
```
### MQTT transport (optional)
```
kubectl apply -f transports/tb-mqtt-transport.yml
```
## 4.Configure Load Balancers
### Configure HTTP(S) Load Balancer
Configure HTTP(S) Load Balancer to access web interface of your ThingsBoard instance. 
Use AWS Certificate Manager to create or import SSL certificate. Note your certificate ARN.
Edit the load balancer configuration and replace YOUR_HTTPS_CERTIFICATE_ARN with your certificate ARN:
```
nano receipts/https-load-balancer.yml
```
Execute the following command to deploy plain https load balancer:
```
kubectl apply -f receipts/https-load-balancer.yml
```
### Configure MQTT Load Balancer (Optional)
Configure MQTT load balancer if you plan to use MQTT protocol to connect devices.
Create TCP load balancer using following command:
```
kubectl apply -f receipts/mqtt-load-balancer.yml
```
The load balancer will forward all TCP traffic for ports 1883 and 8883.
