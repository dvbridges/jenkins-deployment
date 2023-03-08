# Deploy Jenkins on a K8s VM Cluster

This repo provides all the required instructions and K8s
manifests for deploying Jenkins on a Kubernetes VM cluster
built using Vagrant and Virtual Box.

Note, we use a [custom Jenkins Agent image](./jenkins-deploy/jenkins-build/Dockerfile.jenkinsagent) for running the builds. This should fix timeout issues with the agent connecting to the Jenkins Server.

## Build the VM Cluster

The first step automates the build of a Kubernetes multinode VM cluster using Vagrant and VirtualBox. For this, follow the instructions at 

https://devopscube.com/kubernetes-cluster-vagrant/ 
https://github.com/techiescamp/vagrant-kubeadm-kubernetes

If using Mac or Linux, remember to follow the instructions to modify the `/etc/vbox/networks.conf` to allow generation of IP in any ranges for the cluster network.

If you want to control the deployment from the host computer, remember to copy the 
K8s config file used in the Cluster to `$HOME/.kube/config`, so you have the correct Kubectl context set.

## Deploy Jenkins

With a working K8s multi-node cluster, you can deploy Jenkins. For a full explanation of the deployment manifests, check out the [Jenkins Kuberentes guide](https://www.jenkins.io/doc/book/installing/kubernetes/).

For a quick deployment, run the [Jenkins Deploy](./jenkins-deploy/deploy.sh) file. Note, the specification of the node name ("worker-node02") for hosting the volume and the deployment. Also note the addition of the dnsCondig entry in the deployment manifest, providing the additional Google DNS server address so Jenkins Master can resolve the URL for updates and extentions.

## Setting up Jenkins to run on Kubernetes

You should be able to access the Jenkins UI from a webbrowser on your hostmachine
at the IP and NodePort e.g., `10.0.0.12:32000`. The IP should not change for this deployment as we have set the nodeName
in the Jenkins deployment manifest.

Follow the instructions for getting the initial password from the Jenkins pod containing the Jenkins server container, then install the `Kubernetes` and `Pipeline` plug-ins - this may take some time.

The majority of Jenkins setup is explained on the [Kubernetes plug-in](https://plugins.jenkins.io/kubernetes/) webpage and this excellent link by [devopscube](https://devopscube.com/jenkins-build-agents-kubernetes/). Mainly, you will want to:
    1) go to `Manage Jenkins > Configure Cloud` and add a Kubernetes configuration with the name `"Kubernetes"`
    2) Click `Kubernetes Cloud details...`
    3) Set the namespace as `devops-tools` to match your Deployment.
    4) Set the Jenkins URL as `http://jenkins-service:8080` to use our service deployment.
    5) Set a pod label key as "app" with value of "kube-agent"

These values will be used when running Jenkins Agent pods.

## Jenkins Pipelines and Pod Templates

```json
podTemplate(containers: [
    containerTemplate(name: 'jnlp', 
    image: 'dvbridges/jenkins-agent:latest', 
    alwaysPullImage: true)
  ])
{
    node(POD_LABEL) {
        stage('Run shell') {
            sh 'echo hello world'
        }
    }
}
```