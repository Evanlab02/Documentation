# Overview

Azure Functions lets you develop serverless applications on Microsoft Azure. You can write just the code you need for the problem at hand, without worrying about a whole application or the infrastructure to run it.

After completing this module, should be able to:

- Explain functional differences between Azure Functions, Azure Logic Apps, and WebJobs
- Describe Azure Functions hosting plan options
- Describe how Azure Functions scale to meet business needs

## Comparisons
### Compare Azure Functions and Azure Logic Apps

Both Functions and Logic Apps are Azure Services that enable serverless workloads. Azure Functions is a serverless compute service, whereas Azure Logic Apps is a serverless workflow integration platform. Both can create complex _orchestrations_. An orchestration is a collection of functions or steps, called actions in Logic Apps, that are executed to accomplish a complex task.

For Azure Functions, you develop orchestrations by writing code and using the [Durable Functions extension](https://learn.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-overview). For Logic Apps, you create orchestrations by using a GUI or editing configuration files.

The following table lists some of the key differences between Functions and Logic Apps:

| Topic                 | Azure Functions                                                       | Logic Apps                                                                                             |
| --------------------- | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| **Development**       | Code-first (imperative)                                               | Designer-first (declarative)                                                                           |
| **Connectivity**      | About a dozen built-in binding types, write code for custom bindings  | Large collection of connectors, Enterprise Integration Pack for B2B scenarios, build custom connectors |
| **Actions**           | Each activity is an Azure function; write code for activity functions | Large collection of ready-made actions                                                                 |
| **Monitoring**        | Azure Application Insights                                            | Azure portal, Azure Monitor logs                                                                       |
| **Management**        | REST API, Visual Studio                                               | Azure portal, REST API, PowerShell, Visual Studio                                                      |
| **Execution context** | Runs in Azure, or locally                                             | Runs in Azure, locally, or on premises                                                                 |

### Compare Functions and WebJobs

Like Azure Functions, Azure App Service WebJobs with the WebJobs SDK is a code-first integration service that is designed for developers. Both are built on Azure App Service and support features such as source control integration, authentication, and monitoring with Application Insights integration.

Azure Functions is built on the WebJobs SDK, so it shares many of the same event triggers and connections to other Azure services. Here are some factors to consider when you're choosing between Azure Functions and WebJobs with the WebJobs SDK:

| Factor                                          | Functions                                                                                                                                                                                 | WebJobs with WebJobs SDK                                                                                                                       |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **Serverless app model with automatic scaling** | Yes                                                                                                                                                                                       | No                                                                                                                                             |
| **Develop and test in browser**                 | Yes                                                                                                                                                                                       | No                                                                                                                                             |
| **Pay-per-use pricing**                         | Yes                                                                                                                                                                                       | No                                                                                                                                             |
| **Integration with Logic Apps**                 | Yes                                                                                                                                                                                       | No                                                                                                                                             |
| **Trigger events**                              | Timer  <br>Azure Storage queues and blobs  <br>Azure Service Bus queues and topics  <br>Azure Cosmos DB  <br>Azure Event Hubs  <br>HTTP/WebHook (GitHub  <br>Slack)  <br>Azure Event Grid | Timer  <br>Azure Storage queues and blobs  <br>Azure Service Bus queues and topics  <br>Azure Cosmos DB  <br>Azure Event Hubs  <br>File system |
Azure Functions offers more developer productivity than Azure App Service WebJobs does. It also offers more options for programming languages, development environments, Azure service integration, and pricing. For most scenarios, it's the best choice.

## Hosting Plans

| Hosting option                                                                                                 | Service              | Availability             | Container support |
| -------------------------------------------------------------------------------------------------------------- | -------------------- | ------------------------ | ----------------- |
| **[Consumption plan](https://learn.microsoft.com/en-us/azure/azure-functions/consumption-plan)**               | Azure Functions      | Generally available (GA) | None              |
| **[Flex Consumption plan](https://learn.microsoft.com/en-us/azure/azure-functions/flex-consumption-plan)**     | Azure Functions      | Preview                  | None              |
| **[Premium plan](https://learn.microsoft.com/en-us/azure/azure-functions/functions-premium-plan)**             | Azure Functions      | GA                       | Linux             |
| **[Dedicated plan](https://learn.microsoft.com/en-us/azure/azure-functions/dedicated-plan)**                   | Azure Functions      | GA                       | Linux             |
| **[Container Apps](https://learn.microsoft.com/en-us/azure/azure-functions/functions-container-apps-hosting)** | Azure Container Apps | GA                       | Linux             |
Azure App Service infrastructure facilitates Azure Functions hosting on both Linux and Windows virtual machines. The hosting option you choose dictates the following behaviors:

- How your function app is scaled.
- The resources available to each function app instance.
- Support for advanced functionality, such as Azure Virtual Network connectivity.
- Support for Linux containers.

The plan you choose also impacts the costs for running your function code.

### Consumption plan

The Consumption plan is the default hosting plan. Pay for compute resources only when your functions are running (pay-as-you-go) with automatic scale. On the Consumption plan, instances of the Functions host are dynamically added and removed based on the number of incoming events.

### Flex Consumption plan

Get high scalability with compute choices, virtual networking, and pay-as-you-go billing. On the Flex Consumption plan, instances of the Functions host are dynamically added and removed based on the configured per instance concurrency and the number of incoming events.

You can reduce cold starts by specifying the number of pre-provisioned (always ready) instances. Scales automatically based on demand.

### Premium plan

Automatically scales based on demand using prewarmed workers, which run applications with no delay after being idle, runs on more powerful instances, and connects to virtual networks.

Consider the Azure Functions Premium plan in the following situations:

- Your function apps run continuously, or nearly continuously.
- You want more control of your instances and want to deploy multiple function apps on the same plan with event-driven scaling.
- You have a high number of small executions and a high execution bill, but low GB seconds in the Consumption plan.
- You need more CPU or memory options than are provided by consumption plans.
- Your code needs to run longer than the maximum execution time allowed on the Consumption plan.
- You require virtual network connectivity.
- You want to provide a custom Linux image in which to run your functions.

### Dedicated plan

Run your functions within an App Service plan at regular App Service plan rates. Best for long-running scenarios where Durable Functions can't be used.

Consider an App Service plan in the following situations:

- You must have fully predictable billing, or you need to manually scale instances.
- You want to run multiple web apps and function apps on the same plan
- You need access to larger compute size choices.
- Full compute isolation and secure network access provided by an App Service Environment (ASE).
- High memory usage and high scale (ASE).

### Container Apps

Create and deploy containerized function apps in a fully managed environment hosted by Azure Container Apps.

Use the Azure Functions programming model to build event-driven, serverless, cloud native function apps. Run your functions alongside other microservices, APIs, websites, and workflows as container-hosted programs.

Consider hosting your functions on Container Apps in the following situations:

- You want to package custom libraries with your function code to support line-of-business apps.
- You need to migration code execution from on-premises or legacy apps to cloud native microservices running in containers.
- You want to avoid the overhead and complexity of managing Kubernetes clusters and dedicated compute.
- You need the high-end processing power provided by dedicated CPU compute resources for your functions.

## Function App Timeouts

The `functionTimeout` property in the _host.json_ project file specifies the timeout duration for functions in a function app. This property applies specifically to function executions. After the trigger starts function execution, the function needs to return/respond within the timeout duration.

The following table shows the default and maximum values (in minutes) for specific plans:

| Plan                  | Default | Maximum1      |
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

## Scaling Azure Functions

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

## Developing Azure Function Apps

Functions share a few core technical concepts and components, regardless of the language or binding you use.

After completing this module, you'll be able to:

- Explain the key components of a function
- Create triggers and bindings to control when a function runs and where the output is directed
- Connect a function to services in Azure
- Create a function by using Visual Studio Code and the Azure Functions Core Tools

NOTE: In Functions 2.x all functions in a function app must be authored in the same language. In previous versions of the Azure Functions runtime, this wasn't required.

NOTE: Because of limitations on editing function code in the Azure portal, you should develop your functions locally and publish your code project to a function app in Azure. For more information, see [Development limitations in the Azure portal](https://learn.microsoft.com/en-us/azure/azure-functions/functions-how-to-use-azure-function-app-settings#development-limitations-in-the-azure-portal)
### Local project files

A Functions project directory contains the following files in the project root folder, regardless of language:

- `host.json`
- `local.settings.json`
- Other files in the project depend on your language and specific functions.\

The `host.json` metadata file contains configuration options that affect all functions in a function app instance. Other function app configuration options are managed depending on where the function app runs:

- **Deployed to Azure:** in your application settings
- **On your local computer:** in the local.settings.json file.

Configurations in `host.json` related to bindings are applied equally to each function in the function app. You can also override or apply settings per environment using application settings. To learn more, see the [host.json reference](https://learn.microsoft.com/en-us/azure/azure-functions/functions-host-json).

The `local.settings.json` file stores app settings, and settings used by local development tools. Settings in the `local.settings.json` file are used only when you're running your project locally. When you publish your project to Azure, be sure to also add any required settings to the app settings for the function app.

IMPORTANT: Because the `local.settings.json` may contain secrets, such as connection strings, you should never store it in a remote repository.

### Trigger and binding definitions

| Language                                | Configure triggers and bindings by...                   |
| --------------------------------------- | ------------------------------------------------------- |
| C# class library                        | decorating methods and parameters with C# attributes    |
| Java                                    | decorating methods and parameters with Java annotations |
| JavaScript/PowerShell/Python/TypeScript | updating _function.json_ schema                         |

### Binding direction

All triggers and bindings have a direction property in the _function.json_ file:

- For triggers, the direction is always `in`
- Input and output bindings use `in` and `out`
- Some bindings support a special direction `inout`. If you use `inout`, only the **Advanced editor** is available via the **Integrate** tab in the portal.

## Azure Functions trigger and binding example

Suppose you want to write a new row to Azure Table storage whenever a new message appears in Azure Queue storage. This scenario can be implemented using an Azure Queue storage trigger and an Azure Table storage output binding.

Here's a _function.json_ file for this scenario.

```json
{
  "disabled": false,
    "bindings": [
        {
            "type": "queueTrigger",
            "direction": "in",
            "name": "myQueueItem",
            "queueName": "myqueue-items",
            "connection":"MyStorageConnectionAppSetting"
        },
        {
          "tableName": "Person",
          "connection": "MyStorageConnectionAppSetting",
          "name": "tableBinding",
          "type": "table",
          "direction": "out"
        }
  ]
}
```

The first element in the `bindings` array is the Queue storage trigger. The `type` and `direction` properties identify the trigger. The `name` property identifies the function parameter that receives the queue message content. The name of the queue to monitor is in `queueName`, and the connection string is in the app setting identified by `connection`.

The second element in the `bindings` array is the Azure Table Storage output binding. The `type` and `direction` properties identify the binding. The `name` property specifies how the function provides the new table row, in this case by using the function return value. The name of the table is in `tableName`, and the connection string is in the app setting identified by `connection`.

### C# function example

Following is the same example represented in a C# function. The same trigger and binding information, queue and table names, storage accounts, and function parameters for input and output are provided by attributes instead of a _function.json_ file.

```csharp
public static class QueueTriggerTableOutput
{
    [FunctionName("QueueTriggerTableOutput")]
    [return: Table("outTable", Connection = "MY_TABLE_STORAGE_ACCT_APP_SETTING")]
    public static Person Run(
        [QueueTrigger("myqueue-items", Connection = "MY_STORAGE_ACCT_APP_SETTING")]JObject order,
        ILogger log)
    {
        return new Person() {
                PartitionKey = "Orders",
                RowKey = Guid.NewGuid().ToString(),
                Name = order["Name"].ToString(),
                MobileNumber = order["MobileNumber"].ToString() };
    }
}

public class Person
{
    public string PartitionKey { get; set; }
    public string RowKey { get; set; }
    public string Name { get; set; }
    public string MobileNumber { get; set; }
}
```

