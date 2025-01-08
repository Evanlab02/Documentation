## App Service Plans

### Pricing Tiers

The _pricing tier_ of an App Service plan determines what App Service features you get and how much you pay for the plan. There are a few categories of pricing tiers:

- **Shared compute**: **Free** and **Shared**, the two base tiers, runs an app on the same Azure VM as other App Service apps, including apps of other customers. These tiers allocate CPU quotas to each app that runs on the shared resources, and the resources can't scale out.
- **Dedicated compute**: The **Basic**, **Standard**, **Premium**, **PremiumV2**, and **PremiumV3** tiers run apps on dedicated Azure VMs. Only apps in the same App Service plan share the same compute resources. The higher the tier, the more VM instances are available to you for scale-out.
- **Isolated**: The **Isolated** and **IsolatedV2** tiers run dedicated Azure VMs on dedicated Azure Virtual Networks. It provides network isolation on top of compute isolation to your apps. It provides the maximum scale-out capabilities.

App Service on Linux isn't supported on Shared pricing tier.

### Scaling

- An app runs on all the VM instances configured in the App Service plan.
- If multiple apps are in the same App Service plan, they all share the same VM instances.
- If you have multiple deployment slots for an app, all deployment slots also run on the same VM instances.
- If you enable diagnostic logs, perform backups, or run WebJobs, they also use CPU cycles and memory on these VM instances.

### When to isolate your app service plans

Isolate your app into a new App Service plan when:

- The app is resource-intensive.
- You want to scale the app independently from the other apps in the existing plan.
- The app needs resource in a different geographical region.

This way you can allocate a new set of resources for your app and gain greater control of your apps.

## Azure Functions
### Hosting Plans

| Hosting option                                                                                                 | Service              | Availability             | Container support |
| -------------------------------------------------------------------------------------------------------------- | -------------------- | ------------------------ | ----------------- |
| **[Consumption plan](https://learn.microsoft.com/en-us/azure/azure-functions/consumption-plan)**               | Azure Functions      | Generally available (GA) | None              |
| **[Flex Consumption plan](https://learn.microsoft.com/en-us/azure/azure-functions/flex-consumption-plan)**     | Azure Functions      | Preview                  | None              |
| **[Premium plan](https://learn.microsoft.com/en-us/azure/azure-functions/functions-premium-plan)**             | Azure Functions      | GA                       | Linux             |
| **[Dedicated plan](https://learn.microsoft.com/en-us/azure/azure-functions/dedicated-plan)**                   | Azure Functions      | GA                       | Linux             |
| **[Container Apps](https://learn.microsoft.com/en-us/azure/azure-functions/functions-container-apps-hosting)** | Azure Container Apps | GA                       | Linux             |
#### Consumption plan

The Consumption plan is the default hosting plan. Pay for compute resources only when your functions are running (pay-as-you-go) with automatic scale. On the Consumption plan, instances of the Functions host are dynamically added and removed based on the number of incoming events.

#### Flex Consumption plan

Get high scalability with compute choices, virtual networking, and pay-as-you-go billing. On the Flex Consumption plan, instances of the Functions host are dynamically added and removed based on the configured per instance concurrency and the number of incoming events.

You can reduce cold starts by specifying the number of pre-provisioned (always ready) instances. Scales automatically based on demand.
#### Premium plan

Automatically scales based on demand using prewarmed workers, which run applications with no delay after being idle, runs on more powerful instances, and connects to virtual networks.

Consider the Azure Functions Premium plan in the following situations:

- Your function apps run continuously, or nearly continuously.
- You want more control of your instances and want to deploy multiple function apps on the same plan with event-driven scaling.
- You have a high number of small executions and a high execution bill, but low GB seconds in the Consumption plan.
- You need more CPU or memory options than are provided by consumption plans.
- Your code needs to run longer than the maximum execution time allowed on the Consumption plan.
- You require virtual network connectivity.
- You want to provide a custom Linux image in which to run your functions.

#### Dedicated plan

Run your functions within an App Service plan at regular App Service plan rates. Best for long-running scenarios where Durable Functions can't be used.

Consider an App Service plan in the following situations:

- You must have fully predictable billing, or you need to manually scale instances.
- You want to run multiple web apps and function apps on the same plan
- You need access to larger compute size choices.
- Full compute isolation and secure network access provided by an App Service Environment (ASE).
- High memory usage and high scale (ASE).

#### Container Apps

Create and deploy containerized function apps in a fully managed environment hosted by Azure Container Apps.

Use the Azure Functions programming model to build event-driven, serverless, cloud native function apps. Run your functions alongside other microservices, APIs, websites, and workflows as container-hosted programs.

Consider hosting your functions on Container Apps in the following situations:

- You want to package custom libraries with your function code to support line-of-business apps.
- You need to migration code execution from on-premises or legacy apps to cloud native microservices running in containers.
- You want to avoid the overhead and complexity of managing Kubernetes clusters and dedicated compute.
- You need the high-end processing power provided by dedicated CPU compute resources for your functions.

### Function App Timeouts

The `functionTimeout` property in the _host.json_ project file specifies the timeout duration for functions in a function app. This property applies specifically to function executions. After the trigger starts function execution, the function needs to return/respond within the timeout duration.

The following table shows the default and maximum values (in minutes) for specific plans:

| Plan                  | Default | Maximum - 1   |
| --------------------- | ------- | ------------- |
| Consumption plan      | 5       | 10            |
| Flex Consumption plan | 30      | Unlimited - 3 |
| Premium plan          | 30 - 2  | Unlimited - 3 |
| Dedicated plan        | 30 - 2  | Unlimited - 3 |
| Container Apps        | 30 - 5  | Unlimited - 3 |

1. Regardless of the function app timeout setting, 230 seconds is the maximum amount of time that an HTTP triggered function can take to respond to a request.
2. The default timeout for version 1.x of the Functions runtime is _unlimited_.
3. Guaranteed for up to 60 minutes. OS and runtime patching, vulnerability patching, and scale in behaviours can still cancel function executions.
4. In a Flex Consumption plan, the host doesn't enforce an execution time limit. However, there are currently no guarantees because the platform might need to terminate your instances during scale-in, deployments, or to apply updates.
5. When the minimum number of replicas is set to zero, the default timeout depends on the specific triggers used in the app.

### Scaling Azure Functions

| Plan                  | Scale out                                                                                                                                                                                                   | Max # instances                                                            |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| Consumption plan      | Event driven. Scales out automatically, even during periods of high load. Functions infrastructure scales CPU and memory resources by adding more instances based on the number of incoming trigger events. | **Windows:** 200  <br>**Linux:** 100                                       |
| Flex Consumption plan | Per-function scaling. Event-driven scaling decisions are calculated on a per-function basis, which provides a more deterministic way of scaling the functions in your app.                                  | Limited only by total memory usage of all instances across a given region. |
| Premium plan          | Event driven. Scale out automatically based on the number of events that its functions are triggered on.                                                                                                    | **Windows:** 100  <br>**Linux:** 20-100                                    |
| Dedicated plan        | Manual/autoscale                                                                                                                                                                                            | 10-30  <br>100 (ASE)                                                       |
| Container Apps        | Event driven. Scale out automatically by adding more instances of the Functions host, based on the number of events that its functions are triggered on.                                                    | 10-300                                                                     |

1. During scale-out, there's currently a limit of 500 instances per subscription per hour for Linux 1. apps on a Consumption plan.
2. In some regions, Linux apps on a Premium plan can scale to 100 instances.
3. For specific limits for the various App Service plan options, see the [App Service plan limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#app-service-limits).
4. On Container Apps, you can set the maximum number of replicas, which is honoured as long as there's enough cores quota available

## Azure Storage

### Types of storage accounts

Azure Storage offers two performance levels of storage accounts, standard and premium. Each performance level supports different features and has its own pricing model.

- **Standard:** This is the standard general-purpose v2 account and is recommended for most scenarios using Azure Storage.
- **Premium:** Premium accounts offer higher performance by using solid-state drives. If you create a premium account you can choose between three account types, block blobs, page blobs, or file shares.

The following table describes the types of storage accounts recommended by Microsoft for most scenarios using Blob storage.

| Type of storage account     | Supported storage services                                                                | Redundancy options                                                                                                                                                                                                                        | Usage                                                                                                                                                                                                                                     |
| --------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Standard general-purpose v2 | Blob Storage (including Data Lake Storage), Queue Storage, Table Storage, and Azure Files | Locally redundant storage (LRS) / geo-redundant storage (GRS) / read-access geo-redundant storage (RA-GRS)  <br>  <br>Zone-redundant storage (ZRS) / geo-zone-redundant storage (GZRS) / read-access geo-zone-redundant storage (RA-GZRS) | Standard storage account type for blobs, file shares, queues, and tables. Recommended for most scenarios using Azure Storage. If you want support for network file system (NFS) in Azure Files, use the premium file shares account type. |
| Premium block blobs         | Blob Storage (including Data Lake Storage)                                                | LRS and ZRS                                                                                                                                                                                                                               | Premium storage account type for block blobs and append blobs. Recommended for scenarios with high transaction rates or that use smaller objects or require consistently low storage latency.                                             |
| Premium file shares         | Azure Files                                                                               | LRS and ZRS                                                                                                                                                                                                                               | Premium storage account type for file shares only. Recommended for enterprise or high-performance scale applications.                                                                                                                     |
| Premium page blobs          | Page blobs only                                                                           | LRS and ZRS                                                                                                                                                                                                                               | Premium storage account type for page blobs only.                                                                                                                                                                                         |
### Access tiers for block blob data

The available access tiers are:

- The **Hot** access tier, which is optimized for frequent access of objects in the storage account. The Hot tier has the highest storage costs, but the lowest access costs. New storage accounts are created in the hot tier by default.
- The **Cool** access tier, which is optimized for storing large amounts of data that is infrequently accessed and stored for a minimum of 30 days. The Cool tier has lower storage costs and higher access costs compared to the Hot tier.
- The **Cold** access tier, which is optimized for storing data that is infrequently accessed and stored for a minimum of 90 days. The cold tier has lower storage costs and higher access costs compared to the cool tier.
- The **Archive** tier, which is available only for individual block blobs. The archive tier is optimized for data that can tolerate several hours of retrieval latency and remains in the Archive tier for a minimum 180 days. The archive tier is the most cost-effective option for storing data, but accessing that data is more expensive than accessing data in the hot or cool tiers.

If there's a change in the usage pattern of your data, you can switch between these access tiers at any time.

- **Hot** - An online tier optimized for storing data that is accessed frequently.
- **Cool** - An online tier optimized for storing data that is infrequently accessed and stored for a minimum of 30 days.
- **Cold tier** - An online tier optimized for storing data that is infrequently accessed and stored for a minimum of 90 days. The cold tier has lower storage costs and higher access costs compared to the cool tier.
- **Archive** - An offline tier optimized for storing data that is rarely accessed and stored for at least 180 days with flexible latency requirements, on the order of hours.

