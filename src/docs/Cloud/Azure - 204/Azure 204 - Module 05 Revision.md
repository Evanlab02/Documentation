# Implement containerized solutions

After completing this module, you'll be able to:

- Explain the features and benefits Azure Container Registry offers
- Describe how to use ACR Tasks to automate builds and deployments
- Explain the elements in a Dockerfile
- Build and run an image in the ACR by using Azure CLI
- Describe the benefits of Azure Container Instances and how resources are grouped
- Deploy a container instance in Azure by using the Azure CLI
- Start and stop containers using policies
- Set environment variables in your container instances
- Mount file shares in your container instances
- Describe the features benefits of Azure Container Apps
- Deploy container app in Azure by using the Azure CLI
- Utilize Azure Container Apps built-in authentication and authorization
- Create revisions and implement app secrets

## Azure Container Registry

Azure Container Registry (ACR) is a managed, private Docker registry service based on the open-source Docker Registry 2.0. Create and maintain Azure container registries to store and manage your private Docker container images.

Azure Container Registry (ACR) is a managed registry service based on the open-source Docker Registry 2.0. Create and maintain Azure container registries to store and manage your container images and related artifacts.

Use the ACR service with your existing container development and deployment pipelines, or use Azure Container Registry Tasks to build container images in Azure. Build on demand, or fully automate builds with triggers such as source code commits and base image updates.

### Use cases

Pull images from an Azure container registry to various deployment targets:

- **Scalable orchestration systems** that manage containerized applications across clusters of hosts, including Kubernetes, DC/OS, and Docker Swarm.
- **Azure services** that support building and running applications at scale, including Azure Kubernetes Service (AKS), App Service, Batch, and Service Fabric.

Developers can also push to a container registry as part of a container development workflow. For example, target a container registry from a continuous integration and delivery tool such as Azure Pipelines or Jenkins.

Configure ACR Tasks to automatically rebuild application images when their base images are updated, or automate image builds when your team commits code to a Git repository. Create multi-step tasks to automate building, testing, and patching multiple container images in parallel in the cloud.

### Azure Container Registry service tiers

Azure Container Registry is available in multiple service tiers. These tiers provide predictable pricing and several options for aligning to the capacity and usage patterns of your private Docker registry in Azure.

| Tier     | Description                                                                                                                                                                                                                                                                                                                                                                                  |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Basic    | A cost-optimized entry point for developers learning about Azure Container Registry. Basic registries have the same programmatic capabilities as Standard and Premium (such as Microsoft Entra authentication integration, image deletion, and webhooks). However, the included storage and image throughput are most appropriate for lower usage scenarios.                                 |
| Standard | Standard registries offer the same capabilities as Basic, with increased included storage and image throughput. Standard registries should satisfy the needs of most production scenarios.                                                                                                                                                                                                   |
| Premium  | Premium registries provide the highest amount of included storage and concurrent operations, enabling high-volume scenarios. In addition to higher image throughput, Premium adds features such as: geo-replication for managing a single registry across multiple regions, content trust for image tag signing, and private link with private endpoints to restrict access to the registry. |
### Explore storage capabilities

All Azure Container Registry tiers benefit from advanced Azure storage features like encryption-at-rest for image data security and geo-redundancy for image data protection.

- **Encryption-at-rest:** All container images and other artifacts in your registry are encrypted at rest. Azure automatically encrypts an image before storing it, and decrypts it on-the-fly when you or your applications and services pull the image. Optionally apply an extra encryption layer with a customer-managed key.
- **Regional storage:** Azure Container Registry stores data in the region where the registry is created, to help customers meet data residency and compliance requirements. In all regions except Brazil South and Southeast Asia, Azure might also store registry data in a paired region in the same geography. In the Brazil South and Southeast Asia regions, registry data is always confined to the region, to accommodate data residency requirements for those regions. If a regional outage occurs, the registry data might become unavailable and isn't automatically recovered. Customers who wish to have their registry data stored in multiple regions for better performance across different geographies, or who wish to have resiliency in a regional outage event, should enable geo-replication.
- **Geo-replication:** For scenarios requiring high-availability assurance, consider using the geo-replication feature of Premium registries. Geo-replication helps guard against losing access to your registry in a regional failure event. Geo-replication provides other benefits, too, like network-close image storage for faster pushes and pulls in distributed development or deployment scenarios.
- **Zone redundancy:** A feature of the Premium service tier, zone redundancy uses Azure availability zones to replicate your registry to a minimum of three separate zones in each enabled region.
- **Scalable storage:** Azure Container Registry allows you to create as many repositories, images, layers, or tags as you need, up to the registry [storage limit](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-skus#service-tier-features-and-limits). High numbers of repositories and tags can impact the performance of your registry. Periodically delete unused repositories, tags, and images as part of your registry maintenance routine. Deleted registry resources like repositories, images, and tags _can't_ be recovered after deletion.

### Task scenarios

ACR Tasks supports several scenarios to build and maintain container images and other artifacts.

- **Quick task** - Build and push a single container image to a container registry on-demand, in Azure, without needing a local Docker Engine installation. Think `docker build`, `docker push` in the cloud.
- **Automatically triggered tasks** - Enable one or more _triggers_ to build an image:
    - Trigger on source code update
    - Trigger on base image update
    - Trigger on a schedule
- **Multi-step task** - Extend the single image build-and-push capability of ACR Tasks with multi-step, multi-container-based workflows.

Each ACR Task has an associated source code context - the location of a set of source files used to build a container image or other artifact. Example contexts include a Git repository or a local filesystem.

#### Quick Task

Using the familiar `docker build` format, the [az acr build](https://learn.microsoft.com/en-us/cli/azure/acr#az-acr-build) command in the Azure CLI takes a context (the set of files to build), sends it to ACR Tasks and, by default, pushes the built image to its registry upon completion.

#### Trigger task on source code update

Trigger a container image build or multi-step task when code is committed, or a pull request is made or updated, to a Git repository in GitHub or Azure DevOps Services. For example, configure a build task with the Azure CLI command `az acr task create` by specifying a Git repository and optionally a branch and Dockerfile. When your team updates code in the repository, an ACR Tasks-created webhook triggers a build of the container image defined in the repo.

#### Trigger on base image update

You can set up an ACR task to track a dependency on a base image when it builds an application image. When the updated base image is pushed to your registry, or a base image is updated in a public repo such as in Docker Hub, ACR Tasks can automatically build any application images based on it.

#### Schedule a task

Optionally schedule a task by setting up one or more timer triggers when you create or update the task. Scheduling a task is useful for running container workloads on a defined schedule, or running maintenance operations or tests on images pushed regularly to your registry.

#### Multi-step tasks

Multi-step tasks, defined in a [YAML file](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-tasks-reference-yaml) specify individual build and push operations for container images or other artifacts. They can also define the execution of one or more containers, with each step using the container as its execution environment. For example, you can create a multi-step task that automates the following:

1. Build a web application image
2. Run the web application container
3. Build a web application test image
4. Run the web application test container, which performs tests against the running application container
5. If the tests pass, build a Helm chart archive package
6. Perform a `helm upgrade` using the new Helm chart archive package

### Image platforms

By default, ACR Tasks builds images for the Linux OS and the amd64 architecture. Specify the `--platform` tag to build Windows images or Linux images for other architectures. Specify the OS and optionally a supported architecture in OS/architecture format (for example, `--platform Linux/arm`). For ARM architectures, optionally specify a variant in OS/architecture/variant format (for example, `--platform Linux/arm64/v8`):

| OS      | Architecture                       |
| ------- | ---------------------------------- |
| Linux   | AMD64  <br>Arm  <br>Arm64  <br>386 |
| Windows | AMD64                              |

## Azure Container Instances

Azure Container Instances (ACI) offers the fastest and simplest way to run a container in Azure, without having to manage any virtual machines and without having to adopt a higher-level service.

Azure Container Instances (ACI) is a great solution for any scenario that can operate in isolated containers, including simple applications, task automation, and build jobs. Here are some of the benefits:

- **Fast startup**: ACI can start containers in Azure in seconds, without the need to provision and manage a virtual machine (VM)
- **Container access**: ACI enables exposing your container groups directly to the internet with an IP address and a fully qualified domain name (FQDN)
- **Hypervisor-level security**: Isolate your application as completely as it would be in a VM
- **Customer data**: The ACI service stores the minimum customer data required to ensure your container groups are running as expected
- **Custom sizes**: ACI provides optimum utilization by allowing exact specifications of CPU cores and memory
- **Persistent storage**: Mount Azure Files shares directly to a container to retrieve and persist state
- **Linux and Windows**: Schedule both Windows and Linux containers using the same API.

For scenarios where you need full container orchestration, including service discovery across multiple containers, automatic scaling, and coordinated application upgrades, we recommend [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/).

### Container groups

The top-level resource in Azure Container Instances is the _container group_. A container group is a collection of containers that get scheduled on the same host machine. The containers in a container group share a lifecycle, resources, local network, and storage volumes. It's similar in concept to a _pod_ in Kubernetes.

The following diagram shows an example of a container group that includes multiple containers:

![Example container group with two containers, one listening on port 80 and the other listening on port 5000.](https://learn.microsoft.com/en-us/training/wwl-azure/create-run-container-images-azure-container-instances/media/container-groups-example.png)

This example container group:

- Is scheduled on a single host machine.
- Is assigned a DNS name label.
- Exposes a single public IP address, with one exposed port.
- Consists of two containers. One container listens on port 80, while the other listens on port 5000.
- Includes two Azure file shares as volume mounts, and each container mounts one of the shares locally.

#### Deployment

There are two common ways to deploy a multi-container group: use a Resource Manager template or a YAML file. A Resource Manager template is recommended when you need to deploy more Azure service resources (for example, an Azure Files share) when you deploy the container instances. Due to the YAML format's more concise nature, a YAML file is recommended when your deployment includes only container instances.

#### Resource allocation

Azure Container Instances allocates resources such as CPUs, memory, and optionally GPUs (preview) to a container group by adding the resource requests of the instances in the group. Using CPU resources as an example, if you create a container group with two instances, each requesting one CPU, then the container group is allocated two CPUs.

#### Networking

Container groups share an IP address and a port namespace on that IP address. To enable external clients to reach a container within the group, you must expose the port on the IP address and from the container. Because containers within the group share a port namespace, port mapping isn't supported. Containers within a group can reach each other via localhost on the ports that they exposed, even if those ports aren't exposed externally on the group's IP address.

#### Storage

You can specify external volumes to mount within a container group. You can map those volumes into specific paths within the individual containers in a group. Supported volumes include:

- Azure file share
- Secret
- Empty directory
- Cloned git repo

#### Common scenarios

Multi-container groups are useful in cases where you want to divide a single functional task into a few container images. These images might be delivered by different teams and have separate resource requirements.

Example usage could include:

- A container serving a web application and a container pulling the latest content from source control.
- An application container and a logging container. The logging container collects the logs and metrics output by the main application and writes them to long-term storage.
- An application container and a monitoring container. The monitoring container periodically makes a request to the application to ensure that it's running and responding correctly, and raises an alert if it's not.
- A front-end container and a back-end container. The front end might serve a web application, with the back end running a service to retrieve data.

### Container restart policy

When you create a container group in Azure Container Instances, you can specify one of three restart policy settings.

|Restart policy|Description|
|---|---|
|`Always`|Containers in the container group are always restarted. This is the **default** setting applied when no restart policy is specified at container creation.|
|`Never`|Containers in the container group are never restarted. The containers run at most once.|
|`OnFailure`|Containers in the container group are restarted only when the process executed in the container fails (when it terminates with a nonzero exit code). The containers are run at least once.|

#### Specify a restart policy

Specify the `--restart-policy` parameter when you call `az container create`.



```Bash
az container create \
    --resource-group myResourceGroup \
    --name mycontainer \
    --image mycontainerimage \
    --restart-policy OnFailure
```

#### Run to completion

Azure Container Instances starts the container, and then stops it when its application, or script, exits. When Azure Container Instances stops a container whose restart policy is `Never` or `OnFailure`, the container's status is set to **Terminated**.

### Env Values

```Bash
az container create \
    --resource-group myResourceGroup \
    --name mycontainer2 \
    --image mcr.microsoft.com/azuredocs/aci-wordcount:latest 
    --restart-policy OnFailure \
    --environment-variables 'NumWords'='5' 'MinLength'='8'\
```

#### Secure values

Objects with secure values are intended to hold sensitive information like passwords or keys for your application. Using secure values for environment variables is both safer and more flexible than including it in your container's image.

Environment variables with secure values aren't visible in your container's properties. Their values can be accessed only from within the container. For example, container properties viewed in the Azure portal or Azure CLI display only a secure variable's name, not its value.

Set a secure environment variable by specifying the `secureValue` property instead of the regular `value` for the variable's type. The two variables defined in the following YAML demonstrate the two variable types.

```YAML
apiVersion: 2018-10-01
location: eastus
name: securetest
properties:
  containers:
  - name: mycontainer
    properties:
      environmentVariables:
        - name: 'NOTSECRET'
          value: 'my-exposed-value'
        - name: 'SECRET'
          secureValue: 'my-secret-value'
      image: nginx
      ports: []
      resources:
        requests:
          cpu: 1.0
          memoryInGB: 1.5
  osType: Linux
  restartPolicy: Always
tags: null
type: Microsoft.ContainerInstance/containerGroups
```

You would run the following command to deploy the container group with YAML:

```bash
az container create --resource-group myResourceGroup \
    --file secure-env.yaml \
```

### Mounting file share

#### Limitations

- You can only mount Azure Files shares to Linux containers.
- Azure file share volume mount requires the Linux container run as _root_.
- Azure File share volume mounts are limited to CIFS support.

#### Deploy container and mount volume

To mount an Azure file share as a volume in a container by using the Azure CLI, specify the share and volume mount point when you create the container with `az container create`. Following is an example of the command:

```bash
az container create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name hellofiles \
    --image mcr.microsoft.com/azuredocs/aci-hellofiles \
    --dns-name-label aci-demo \
    --ports 80 \
    --azure-file-volume-account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --azure-file-volume-account-key $STORAGE_KEY \
    --azure-file-volume-share-name $ACI_PERS_SHARE_NAME \
    --azure-file-volume-mount-path /aci/logs/
```

The `--dns-name-label` value must be unique within the Azure region where you create the container instance. Update the value in the preceding command if you receive a **DNS name label** error message when you execute the command.

#### Deploy container and mount volume - YAML

You can also deploy a container group and mount a volume in a container with the Azure CLI and a YAML template. Deploying by YAML template is the preferred method when deploying container groups consisting of multiple containers.

The following YAML template defines a container group with one container created with the `aci-hellofiles` image. The container mounts the Azure file share _acishare_ created previously as a volume. Following is an example YAML file.

```YAML
apiVersion: '2019-12-01'
location: eastus
name: file-share-demo
properties:
  containers:
  - name: hellofiles
    properties:
      environmentVariables: []
      image: mcr.microsoft.com/azuredocs/aci-hellofiles
      ports:
      - port: 80
      resources:
        requests:
          cpu: 1.0
          memoryInGB: 1.5
      volumeMounts:
      - mountPath: /aci/logs/
        name: filesharevolume
  osType: Linux
  restartPolicy: Always
  ipAddress:
    type: Public
    ports:
      - port: 80
    dnsNameLabel: aci-demo
  volumes:
  - name: filesharevolume
    azureFile:
      sharename: acishare
      storageAccountName: <Storage account name>
      storageAccountKey: <Storage account key>
tags: {}
type: Microsoft.ContainerInstance/containerGroups
```

#### Mount multiple volumes

To mount multiple volumes in a container instance, you must deploy using an Azure Resource Manager template or a YAML file. To use a template or YAML file, provide the share details and define the volumes by populating the `volumes` array in the `properties` section of the template.

For example, if you created two Azure Files shares named _share1_ and _share2_ in storage account _myStorageAccount_, the `volumes` array in a Resource Manager template would appear similar to the following:

```JSON
"volumes": [{
  "name": "myvolume1",
  "azureFile": {
    "shareName": "share1",
    "storageAccountName": "myStorageAccount",
    "storageAccountKey": "<storage-account-key>"
  }
},
{
  "name": "myvolume2",
  "azureFile": {
    "shareName": "share2",
    "storageAccountName": "myStorageAccount",
    "storageAccountKey": "<storage-account-key>"
  }
}]
```

Next, for each container in the container group in which you'd like to mount the volumes, populate the `volumeMounts` array in the `properties` section of the container definition. For example, this mounts the two volumes, _myvolume1_ and _myvolume2_, previously defined:

```JSON
"volumeMounts": [{
  "name": "myvolume1",
  "mountPath": "/mnt/share1/"
},
{
  "name": "myvolume2",
  "mountPath": "/mnt/share2/"
}]
```

## Azure Container Apps

Azure Container Apps enables you to run microservices and containerized applications on a serverless platform that runs on top of Azure Kubernetes Service. Common uses of Azure Container Apps include:

- Deploying API endpoints
- Hosting background processing applications
- Handling event-driven processing
- Running microservices

Applications built on Azure Container Apps can dynamically scale based on: HTTP traffic, event-driven processing, CPU or memory load, and any [KEDA-supported scaler](https://keda.sh/docs/scalers/).

With Azure Container Apps, you can:

- Run multiple container revisions and manage the container app's application lifecycle.
- Autoscale your apps based on any KEDA-supported scale trigger. Most applications can scale to zero. (Applications that scale on CPU or memory load can't scale to zero.)
- Enable HTTPS ingress without having to manage other Azure infrastructure.
- Split traffic across multiple versions of an application for Blue/Green deployments and A/B testing scenarios.
- Use internal ingress and service discovery for secure internal-only endpoints with built-in DNS-based service discovery.
- Build microservices with [Dapr](https://docs.dapr.io/concepts/overview/) and access its rich set of APIs.
- Run containers from any registry, public or private, including Docker Hub and Azure Container Registry (ACR).
- Use the Azure CLI extension, Azure portal or ARM templates to manage your applications.
- Provide an existing virtual network when creating an environment for your container apps.
- Securely manage secrets directly in your application.
- Monitor logs using Azure Log Analytics.

### Azure Container Apps environments

Individual container apps are deployed to a single Container Apps environment, which acts as a secure boundary around groups of container apps. Container Apps in the same environment are deployed in the same virtual network and write logs to the same Log Analytics workspace. You might provide an existing virtual network when you create an environment.

Reasons to deploy container apps to the same environment include situations when you need to:

- Manage related services
- Deploy different applications to the same virtual network
- Instrument [Dapr](https://docs.dapr.io/concepts/overview/) applications that communicate via the Dapr service invocation API
- Have applications to share the same Dapr configuration
- Have applications share the same log analytics workspace

Reasons to deploy container apps to different environments include situations when you want to ensure:

- Two applications never share the same compute resources
- Two Dapr applications can't communicate via the Dapr service invocation API

### Microservices with Azure Container Apps

Microservice architectures allow you to independently develop, upgrade, version, and scale core areas of functionality in an overall system. Azure Container Apps provides the foundation for deploying microservices featuring:

- Independent scaling, versioning, and upgrades
- Service discovery
- Native [Dapr](https://docs.dapr.io/concepts/overview/) integration

### Dapr integration

When you implement a system composed of microservices, function calls are spread across the network. To support the distributed nature of microservices, you need to account for failures, retries, and timeouts. While Container Apps features the building blocks for running microservices, use of Dapr provides an even richer microservices programming model. Dapr includes features like observability, pub/sub, and service-to-service invocation with mutual TLS, retries, and more.

### Deploy a container app

Install the Azure Container Apps extension for the CLI.

```bash
az extension add --name containerapp --upgrade
```

Register the `Microsoft.App` namespace.

```bash
az provider register --namespace Microsoft.App
```

Register the `Microsoft.OperationalInsights` provider for the Azure Monitor Log Analytics workspace if you haven't used it before.

```bash
az provider register --namespace Microsoft.OperationalInsights
```

Set env values

```
myRG=az204-appcont-rg
myLocation=<location>
myAppContEnv=az204-env-$RANDOM
```

Create the resource group for your container app.

```bash
az group create \
    --name $myRG \
    --location $myLocation
```

Create environment

```bash
az containerapp env create \
    --name $myAppContEnv \
    --resource-group $myRG \
    --location $myLocation
```

Deploy a sample app container image by using the `containerapp create` command.

```bash
az containerapp create \
    --name my-container-app \
    --resource-group $myRG \
    --environment $myAppContEnv \
    --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest \
    --target-port 80 \
    --ingress 'external' \
    --query properties.configuration.ingress.fqdn
```

### Explore containers in Azure Container Apps

Azure Container Apps manages the details of Kubernetes and container orchestration for you. Containers in Azure Container Apps can use any runtime, programming language, or development stack of your choice.

![Diagram showing how containers for an Azure Container App are grouped together in pods inside revision snapshots.](https://learn.microsoft.com/en-us/training/wwl-azure/implement-azure-container-apps/media/azure-container-apps-containers.png)

Azure Container Apps supports any Linux-based x86-64 (`linux/amd64`) container image. There's no required base container image, and if a container crashes it automatically restarts.

#### Configuration

The following code is an example of the `containers` array in the `properties.template` section of a container app resource template. The excerpt shows some of the available configuration options when setting up a container when using Azure Resource Manager (ARM) templates. Changes to the template ARM configuration section trigger a new container app revision.

```JSON
"containers": [
  {
       "name": "main",
       "image": "[parameters('container_image')]",
    "env": [
      {
        "name": "HTTP_PORT",
        "value": "80"
      },
      {
        "name": "SECRET_VAL",
        "secretRef": "mysecret"
      }
    ],
    "resources": {
      "cpu": 0.5,
      "memory": "1Gi"
    },
    "volumeMounts": [
      {
        "mountPath": "/myfiles",
        "volumeName": "azure-files-volume"
      }
    ]
    "probes":[
        {
            "type":"liveness",
            "httpGet":{
            "path":"/health",
            "port":8080,
            "httpHeaders":[
                {
                    "name":"Custom-Header",
                    "value":"liveness probe"
                }]
            },
            "initialDelaySeconds":7,
            "periodSeconds":3
// file is truncated for brevity
```

#### Multiple containers

You can define multiple containers in a single container app to implement the [sidecar pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/sidecar). The containers in a container app share hard disk and network resources and experience the same application lifecycle.

Examples of sidecar containers include:

- An agent that reads logs from the primary app container on a shared volume and forwards them to a logging service.
- A background process that refreshes a cache used by the primary app container in a shared volume.

Running multiple containers in a single container app is an advanced use case. In most situations where you want to run multiple containers, such as when implementing a microservice architecture, deploy each service as a separate container app.

To run multiple containers in a container app, add more than one container in the containers array of the container app template.

#### Container registries

You can deploy images hosted on private registries by providing credentials in the Container Apps configuration.

To use a container registry, you define the required fields in registries array in the properties.configuration section of the container app resource template. The passwordSecretRef field identifies the name of the secret in the secrets array name where you defined the password.

```JSON
{
  ...
  "registries": [{
    "server": "docker.io",
    "username": "my-registry-user-name",
    "passwordSecretRef": "my-password-secret-name"
  }]
}
```

With the registry information added, the saved credentials can be used to pull a container image from the private registry when your app is deployed.

#### Limitations

Azure Container Apps has the following limitations:

- **Privileged containers**: Azure Container Apps can't run privileged containers. If your program attempts to run a process that requires root access, the application inside the container experiences a runtime error.
- **Operating system**: Linux-based (`linux/amd64`) container images are required.

### Authentication and Authorization

Azure Container Apps provides built-in authentication and authorization features to secure your external ingress-enabled container app with minimal or no code. The built-in authentication feature for Container Apps can save you time and effort by providing out-of-the-box authentication with federated identity providers, allowing you to focus on the rest of your application.

- Azure Container Apps provides access to various built-in authentication providers.
- The built-in auth features don’t require any particular language, SDK, security expertise, or even any code that you have to write.

This feature should only be used with HTTPS. Ensure `allowInsecure` is disabled on your container app's ingress configuration. You can configure your container app for authentication with or without restricting access to your site content and APIs.

- To restrict app access only to authenticated users, set its _Restrict access_ setting to **Require authentication**.
- To authenticate but not restrict access, set its _Restrict access_ setting to **Allow unauthenticated** access.

#### Identity providers

Container Apps uses federated identity, in which a third-party identity provider manages the user identities and authentication flow for you. The following identity providers are available by default:

|Provider|Sign-in endpoint|How-To guidance|
|---|---|---|
|Microsoft Identity Platform|`/.auth/login/aad`|[Microsoft Identity Platform](https://learn.microsoft.com/en-us/azure/container-apps/authentication-azure-active-directory)|
|Facebook|`/.auth/login/facebook`|[Facebook](https://learn.microsoft.com/en-us/azure/container-apps/authentication-facebook)|
|GitHub|`/.auth/login/github`|[GitHub](https://learn.microsoft.com/en-us/azure/container-apps/authentication-github)|
|Google|`/.auth/login/google`|[Google](https://learn.microsoft.com/en-us/azure/container-apps/authentication-google)|
|Twitter|`/.auth/login/twitter`|[Twitter](https://learn.microsoft.com/en-us/azure/container-apps/authentication-twitter)|
|Any OpenID Connect provider|`/.auth/login/<providerName>`|[OpenID Connect](https://learn.microsoft.com/en-us/azure/container-apps/authentication-openid)|

When you use one of these providers, the sign-in endpoint is available for user authentication and authentication token validation from the provider. You can provide your users with any number of these provider options.

#### Feature architecture

The authentication and authorization middleware component is a feature of the platform that runs as a sidecar container on each replica in your application. When enabled, every incoming HTTP request passes through the security layer before being handled by your application.

![Diagram showing requests being intercepted by a sidecar container interacting with identity providers before allowing traffic to the app container.](https://learn.microsoft.com/en-us/training/wwl-azure/implement-azure-container-apps/media/container-apps-authorization-architecture.png)

The platform middleware handles several things for your app:

- Authenticates users and clients with the specified identity providers
- Manages the authenticated session
- Injects identity information into HTTP request headers

The authentication and authorization module runs in a separate container, isolated from your application code. As the security container doesn't run in-process, no direct integration with specific language frameworks is possible. However, relevant information your app needs is provided in request headers.
#### Authentication flow

The authentication flow is the same for all providers, but differs depending on whether you want to sign in with the provider's SDK:

- **Without provider SDK** (server-directed flow or server flow): The application delegates federated sign-in to Container Apps. Delegation is typically the case with browser apps, which presents the provider's sign-in page to the user.
- **With provider SDK** (client-directed flow or client flow): The application signs users in to the provider manually and then submits the authentication token to Container Apps for validation. This approach is typical for browser-less apps that don't present the provider's sign-in page to the user. An example is a native mobile app that signs users in using the provider's SDK.

### Managing revisions

By default, Container Apps creates a unique revision name with a suffix consisting of a semi-random string of alphanumeric characters. For example, for a container app named _album-api_, setting the revision suffix name to _1st-revision_ would create a revision with the name _album-api--1st-revision_. You can set the revision suffix in the ARM template, through the Azure CLI `az containerapp create` and `az containerapp update` commands, or when creating a revision via the Azure portal.

#### Updating your container app

With the `az containerapp update` command you can modify environment variables, compute resources, scale parameters, and deploy a different image. If your container app update includes [revision-scope changes](https://learn.microsoft.com/en-us/azure/container-apps/revisions#revision-scope-changes), a new revision is generated.

```Bash
az containerapp update \
  --name <APPLICATION_NAME> \
  --resource-group <RESOURCE_GROUP_NAME> \
  --image <IMAGE_NAME>
```

You can list all revisions associated with your container app with the `az containerapp revision list` command.

```Bash
az containerapp revision list \
  --name <APPLICATION_NAME> \
  --resource-group <RESOURCE_GROUP_NAME> \
  -o table
```

#### Manage secrets in Azure Container Apps

Azure Container Apps allows your application to securely store sensitive configuration values. Once secrets are defined at the application level, secured values are available to container apps. Specifically, you can reference secured values inside scale rules.

- Secrets are scoped to an application, outside of any specific revision of an application.
- Adding, removing, or changing secrets doesn't generate new revisions.
- Each application revision can reference one or more secrets.
- Multiple revisions can reference the same secrets.

An updated or deleted secret doesn't automatically affect existing revisions in your app. When a secret is updated or deleted, you can respond to changes in one of two ways:

1. Deploy a new revision.
2. Restart an existing revision.

Before you delete a secret, deploy a new revision that no longer references the old secret. Then deactivate all revisions that reference the secret.

#### Defining secrets

When you create a container app, secrets are defined using the `--secrets` parameter.

- The parameter accepts a space-delimited set of name/value pairs.
- Each pair is delimited by an equals sign.

In the example below, a connection string to a queue storage account is declared in the `--secrets` parameter. The value for queue-connection-string comes from an environment variable named `$CONNECTION_STRING`.

```Bash
az containerapp create \
  --resource-group "my-resource-group" \
  --name queuereader \
  --environment "my-environment-name" \
  --image demos/queuereader:v1 \
  --secrets "queue-connection-string=$CONNECTION_STRING"
```

After declaring secrets at the application level, you can reference them in environment variables when you create a new revision in your container app. When an environment variable references a secret, its value is populated with the value defined in the secret. To reference a secret in an environment variable in the Azure CLI, set its value to `secretref:`, followed by the name of the secret.

The following example shows an application that declares a connection string at the application level. This connection is referenced in a container environment variable.

```Bash
az containerapp create \
  --resource-group "my-resource-group" \
  --name myQueueApp \
  --environment "my-environment-name" \
  --image demos/myQueueApp:v1 \
  --secrets "queue-connection-string=$CONNECTIONSTRING" \
  --env-vars "QueueName=myqueue" "ConnectionString=secretref:queue-connection-string"
```

### DAPR

Please view: https://learn.microsoft.com/en-us/training/modules/implement-azure-container-apps/7-explore-distributed-application-runtime
