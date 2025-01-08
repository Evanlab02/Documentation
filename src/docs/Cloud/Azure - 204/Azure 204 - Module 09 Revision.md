# Develop event-based solutions

## Explore Azure Event Grid

After completing this module, you'll be able to:

- Describe how Event Grid operates and how it connects to services and event handlers.
- Explain how Event Grid delivers events and how it handles errors.
- Implement authentication and authorization.
- Route custom events to web endpoint by using Azure CLI.

Azure Event Grid is a highly scalable, fully managed Pub Sub message distribution service that offers flexible message consumption patterns using the Hypertext Transfer Protocol (HTTP) and Message Queuing Telemetry Transport (MQTT) protocols. With Azure Event Grid, you can build data pipelines with device data, integrate applications, and build event-driven serverless architectures. Event Grid enables clients to publish and subscribe to messages over the MQTT v3.1.1 and v5.0 protocols to support Internet of Things (IoT) solutions. Through HTTP, Event Grid enables you to build event-driven solutions where a publisher service announces its system state changes (events) to subscriber applications. Event Grid can be configured to send events to subscribers (push delivery) or subscribers can connect to Event Grid to read events (pull delivery). Event Grid supports CloudEvents 1.0 specification to provide interoperability across systems.

### Concepts in Azure Event Grid

#### Publishers

A publisher is the application that sends events to Event Grid. It can be the same application where the events originated, the event source. Azure services publish events to Event Grid to announce an occurrence in their service. You can publish events from your own application. Organizations that host services outside of Azure can publish events through Event Grid too.

A _partner_ is a kind of publisher that sends events from its system to make them available to Azure customers. Partners not only can publish events to Azure Event Grid, but they can also receive events from it. These capabilities are enabled through the Partner Events feature.

#### Events and CloudEvents

An event is the smallest amount of information that fully describes something that happened in a system. Every event has common information like `source` of the event, the `time` the event took place, and a unique identifier. Every event also has specific information that is only relevant to the specific type of event.

Event Grid conforms to Cloud Native Computing Foundation’s open standard [CloudEvents 1.0](https://github.com/cloudevents/spec) specification using the [HTTP protocol binding](https://github.com/cloudevents/spec/blob/v1.0.2/cloudevents/bindings/http-protocol-binding.md) with [JSON format](https://github.com/cloudevents/spec/blob/v1.0.2/cloudevents/formats/json-format.md). It means that your solutions publish and consume event messages using a format like the following example:

```JSON
{
    "specversion" : "1.0",
    "type" : "com.yourcompany.order.created",
    "source" : "https://yourcompany.com/orders/",
    "subject" : "O-28964",
    "id" : "A234-1234-1234",
    "time" : "2018-04-05T17:31:00Z",
    "comexampleextension1" : "value",
    "comexampleothervalue" : 5,
    "datacontenttype" : "application/json",
    "data" : {
       "orderId" : "O-28964",
       "URL" : "https://com.yourcompany/orders/O-28964"
    }
}
```

The maximum allowed size for an event is 1 MB. Events over 64 KB are charged in 64-KB increments.

#### Event sources

An event source is where the event happens. Each event source is related to one or more event types. For example, Azure Storage is the event source for blob created events. IoT Hub is the event source for device created events. Your application is the event source for custom events that you define. Event sources are responsible for sending events to Event Grid.

#### Topics

A topic holds events that have been published to Event Grid. You typically use a topic resource for a collection of related events. To respond to certain types of events, subscribers (an Azure service or other applications) decide which topics to subscribe to. There are several kinds of topics: custom topics, system topics, and partner topics.

**System topics** are built-in topics provided by Azure services. You don't see system topics in your Azure subscription because the publisher owns the topics, but you can subscribe to them. To subscribe, you provide information about the resource you want to receive events from. As long as you have access to the resource, you can subscribe to its events.

**Custom topics** are application and third-party topics. When you create or are assigned access to a custom topic, you see that custom topic in your subscription.

**Partner topics** are a kind of topic used to subscribe to events published by a partner. The feature that enables this type of integration is called Partner Events. Through that integration, you get a partner topic where events from a partner system are made available. Once you have a partner topic, you create an event subscription as you would do for any other type of topic.

#### Event subscriptions

A subscription tells Event Grid which events on a topic you're interested in receiving. When creating the subscription, you provide an endpoint for handling the event. You can filter the events that are sent to the endpoint. You can filter by event type, or subject pattern. Set an expiration for event subscriptions that are only needed for a limited time and you don't want to worry about cleaning up those subscriptions.

#### Event handlers

From an Event Grid perspective, an event handler is the place where the event is sent. The handler takes some further action to process the event. Event Grid supports several handler types. You can use a supported Azure service or your own webhook as the handler. Depending on the type of handler, Event Grid follows different mechanisms to guarantee the delivery of the event. For HTTP webhook event handlers, the event is retried until the handler returns a status code of `200 – OK`. For Azure Storage Queue, the events are retried until the Queue service successfully processes the message push into the queue.

#### Security

Event Grid provides security for subscribing to topics and when publishing events to topics. When subscribing, you must have adequate permissions on the Event Grid topic. If using push delivery, the event handler is an Azure service, and a managed identity is used to authenticate Event Grid, the managed identity should have an appropriate RBAC role. For example, if sending events to Event Hubs, the managed identity used in the event subscription should be a member of the Event Hubs Data Sender role.

### Discover event schemas

Azure Event Grid supports two types of event shemas: Event Grid event schema and Cloud event schema. Events consist of a set of four required string properties. The properties are common to all events from any publisher.

The data object has properties that are specific to each publisher. For system topics, these properties are specific to the resource provider, such as Azure Storage or Azure Event Hubs.

Event sources send events to Azure Event Grid in an array, which can have several event objects. When posting events to an Event Grid topic, the array can have a total size of up to 1 MB. Each event in the array is limited to 1 MB. If an event or the array is greater than the size limits, you receive the response `413 Payload Too Large`. Operations are charged in 64 KB increments though. So, events over 64 KB incur operations charges as though they were multiple events. For example, an event that is 130 KB would incur charges as though it were three separate events.

Event Grid sends the events to subscribers in an array that has a single event. You can find the JSON schema for the Event Grid event and each Azure publisher's data payload in the [Event Schema store](https://github.com/Azure/azure-rest-api-specs/tree/master/specification/eventgrid/data-plane).

#### Event schema

The following example shows the properties that are used by all event publishers:

```JSON
[
  {
    "topic": string,
    "subject": string,
    "id": string,
    "eventType": string,
    "eventTime": string,
    "data":{
      object-unique-to-each-publisher
    },
    "dataVersion": string,
    "metadataVersion": string
  }
]
```

#### Event properties

All events have the same following top-level data:

| Property        | Type   | Required                                                                                                                                              | Description                                                                                                                          |
| --------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| topic           | string | No. If not included, Event Grid stamps onto the event. If included, it must match the Event Grid topic Azure Resource Manager ID exactly.             | Full resource path to the event source. This field isn't writeable. Event Grid provides this value.                                  |
| subject         | string | Yes                                                                                                                                                   | Publisher-defined path to the event subject.                                                                                         |
| eventType       | string | Yes                                                                                                                                                   | One of the registered event types for this event source.                                                                             |
| eventTime       | string | Yes                                                                                                                                                   | The time the event is generated based on the provider's UTC time.                                                                    |
| id              | string | Yes                                                                                                                                                   | Unique identifier for the event.                                                                                                     |
| data            | object | No                                                                                                                                                    | Event data specific to the resource provider.                                                                                        |
| dataVersion     | string | No. If not included, it's stamped with an empty value.                                                                                                | The schema version of the data object. The publisher defines the schema version.                                                     |
| metadataVersion | string | No. If not included, Event Grid stamps onto the event. If included, must match the Event Grid Schema `metadataVersion` exactly (currently, only `1`). | The schema version of the event metadata. Event Grid defines the schema of the top-level properties. Event Grid provides this value. |

For custom topics, the event publisher determines the data object. The top-level data should have the same fields as standard resource-defined events.

When publishing events to custom topics, create subjects for your events that make it easy for subscribers to know whether they're interested in the event. Subscribers use the subject to filter and route events. Consider providing the path for where the event happened, so subscribers can filter by segments of that path. The path enables subscribers to narrowly or broadly filter events. For example, if you provide a three segment path like `/A/B/C` in the subject, subscribers can filter by the first segment `/A` to get a broad set of events. Those subscribers get events with subjects like `/A/B/C` or `/A/D/E`. Other subscribers can filter by `/A/B` to get a narrower set of events.

Sometimes your subject needs more detail about what happened. For example, the **Storage Accounts** publisher provides the subject `/blobServices/default/containers/<container-name>/blobs/<file>` when a file is added to a container. A subscriber could filter by the path `/blobServices/default/containers/testcontainer` to get all events for that container but not other containers in the storage account. A subscriber could also filter or route by the suffix `.txt` to only work with text files.

#### Cloud events schema

In addition to its default event schema, Azure Event Grid natively supports events in the JSON implementation of CloudEvents v1.0 and HTTP protocol binding. CloudEvents is an open specification for describing event data.

CloudEvents simplifies interoperability by providing a common event schema for publishing, and consuming cloud based events. This schema allows for uniform tooling, standard ways of routing & handling events, and universal ways of deserializing the outer event schema. With a common schema, you can more easily integrate work across platforms.

Here's an example of an Azure Blob Storage event in CloudEvents format:

```JSON
{
    "specversion": "1.0",
    "type": "Microsoft.Storage.BlobCreated",  
    "source": "/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Storage/storageAccounts/{storage-account}",
    "id": "9aeb0fdf-c01e-0131-0922-9eb54906e209",
    "time": "2019-11-18T15:13:39.4589254Z",
    "subject": "blobServices/default/containers/{storage-container}/blobs/{new-file}",
    "dataschema": "#",
    "data": {
        "api": "PutBlockList",
        "clientRequestId": "4c5dd7fb-2c48-4a27-bb30-5361b5de920a",
        "requestId": "9aeb0fdf-c01e-0131-0922-9eb549000000",
        "eTag": "0x8D76C39E4407333",
        "contentType": "image/png",
        "contentLength": 30699,
        "blobType": "BlockBlob",
        "url": "https://gridtesting.blob.core.windows.net/testcontainer/{new-file}",
        "sequencer": "000000000000000000000000000099240000000000c41c18",
        "storageDiagnostics": {
            "batchId": "681fe319-3006-00a8-0022-9e7cde000000"
        }
    }
}
```

A detailed description of the available fields, their types, and definitions in CloudEvents v1.0 is [available here](https://github.com/cloudevents/spec/blob/v1.0/spec.md#required-attributes).

The headers values for events delivered in the CloudEvents schema and the Event Grid schema are the same except for `content-type`. For CloudEvents schema, that header value is `"content-type":"application/cloudevents+json; charset=utf-8"`. For Event Grid schema, that header value is `"content-type":"application/json; charset=utf-8"`.

You can use Event Grid for both input and output of events in CloudEvents schema. You can use CloudEvents for system events, like Blob Storage events and IoT Hub events, and custom events. It can also transform those events on the wire back and forth.

### Explore event delivery durability

Event Grid provides durable delivery. It tries to deliver each event at least once for each matching subscription immediately. If a subscriber's endpoint doesn't acknowledge receipt of an event or if there's a failure, Event Grid retries delivery based on a fixed retry schedule and retry policy. By default, Event Grid delivers one event at a time to the subscriber, and the payload is an array with a single event.

![An image](../../Assets/Pasted image 20240824144339.png)
#### Retry schedule

When Event Grid receives an error for an event delivery attempt, Event Grid decides whether it should: retry the delivery, dead-letter the event, or drop the event based on the type of the error.

If the error returned by the subscribed endpoint is a configuration-related error that can't be fixed with retries, Event Grid will either: perform dead-lettering on the event, or drop the event if dead-letter isn't configured.

The following table describes the types of endpoints and errors for which retry doesn't happen:

| Endpoint Type   | Error codes                                                              |
| --------------- | ------------------------------------------------------------------------ |
| Azure Resources | 400 (Bad request), 413 (Request entity is too large)                     |
| Webhook         | 400 (Bad request), 413 (Request entity is too large), 401 (Unauthorized) |

![An image](../../Assets/Pasted image 20240824144515.png)

If the error returned by the subscribed endpoint isn't among the previous list, Event Grid waits 30 seconds for a response after delivering a message. After 30 seconds, if the endpoint hasn’t responded, the message is queued for retry. Event Grid uses an exponential backoff retry policy for event delivery.

If the endpoint responds within 3 minutes, Event Grid attempts to remove the event from the retry queue on a best effort basis but duplicates might still be received. Event Grid adds a small randomization to all retry steps and might opportunistically skip certain retries if an endpoint is consistently unhealthy, down for a long period, or appears to be overwhelmed.

#### Retry policy

You can customize the retry policy when creating an event subscription by using the following two configurations. An event is dropped if either of the limits of the retry policy is reached.

- **Maximum number of attempts** - The value must be an integer between 1 and 30. The default value is 30.
- **Event time-to-live (TTL)** - The value must be an integer between 1 and 1440. The default value is 1440 minutes

The following example shows setting the maximum number of attempts to 18 by using the Azure CLI.

```bash
az eventgrid event-subscription create \
  -g gridResourceGroup \
  --topic-name <topic_name> \
  --name <event_subscription_name> \
  --endpoint <endpoint_URL> \
  --max-delivery-attempts 18
```

#### Output batching

You can configure Event Grid to batch events for delivery for improved HTTP performance in high-throughput scenarios. Batching is turned off by default and can be turned on by subscription via the portal, CLI, PowerShell, or SDKs.

Batched delivery has two settings:

- **Max events per batch** - Maximum number of events Event Grid delivers per batch. This number won't be exceeded, however fewer events might be delivered if no other events are available at the time of publish. Event Grid doesn't delay events to create a batch if fewer events are available. Must be between 1 and 5,000.
- **Preferred batch size in kilobytes** - Target ceiling for batch size in kilobytes. Similar to max events, the batch size might be smaller if more events aren't available at the time of publish. It's possible that a batch is larger than the preferred batch size _if_ a single event is larger than the preferred size. For example, if the preferred size is 4 KB and a 10-KB event is pushed to Event Grid, the 10-KB event is delivered in its own batch rather than being dropped.

#### Delayed delivery

As an endpoint experiences delivery failures, Event Grid begins to delay the delivery and retry of events to that endpoint. For example, if the first 10 events published to an endpoint fail, Event Grid assumes that the endpoint is experiencing issues and delays all subsequent retries, and new deliveries, for some time - in some cases up to several hours.

The functional purpose of delayed delivery is to protect unhealthy endpoints and the Event Grid system. Without back-off and delay of delivery to unhealthy endpoints, Event Grid's retry policy and volume capabilities can easily overwhelm a system.

#### Dead-letter events

When Event Grid can't deliver an event within a certain time period or after trying to deliver the event a specific number of times, it can send the undelivered event to a storage account. This process is known as **dead-lettering**. Event Grid dead-letters an event when **one of the following** conditions is met.

- Event isn't delivered within the **time-to-live** period.
- The **number of tries** to deliver the event exceeds the limit.

If either of the conditions is met, the event is dropped or dead-lettered. By default, Event Grid doesn't turn on dead-lettering. To enable it, you must specify a storage account to hold undelivered events when creating the event subscription. You pull events from this storage account to resolve deliveries.

If Event Grid receives a 400 (Bad Request) or 413 (Request Entity Too Large) response code, it immediately schedules the event for dead-lettering. These response codes indicate delivery of the event failed.

There's a five-minute delay between the last attempt to deliver an event and delivery to the dead-letter location. This delay is intended to reduce the number of Blob storage operations. If the dead-letter location is unavailable for four hours, the event is dropped.

#### Custom delivery properties

Event subscriptions allow you to set up HTTP headers that are included in delivered events. This capability allows you to set custom headers that are required by a destination. You can set up to 10 headers when creating an event subscription. Each header value shouldn't be greater than 4,096 bytes. You can set custom headers on the events that are delivered to the following destinations:

- Webhooks
- Azure Service Bus topics and queues
- Azure Event Hubs
- Relay Hybrid Connections

Before setting the dead-letter location, you must have a storage account with a container. You provide the endpoint for this container when creating the event subscription.

### Control access to events

Azure Event Grid allows you to control the level of access given to different users to do various management operations such as list event subscriptions, create new ones, and generate keys. Event Grid uses Azure role-based access control (Azure RBAC).

#### Built-in roles

Event Grid provides the following built-in roles:

| Role                                | Description                                               |
| ----------------------------------- | --------------------------------------------------------- |
| Event Grid Subscription Reader      | Lets you read Event Grid event subscriptions.             |
| Event Grid Subscription Contributor | Lets you manage Event Grid event subscription operations. |
| Event Grid Contributor              | Lets you create and manage Event Grid resources.          |
| Event Grid Data Sender              | Lets you send events to Event Grid topics.                |

The Event Grid Subscription Reader and Event Grid Subscription Contributor roles are for managing event subscriptions. They're important when implementing event domains because they give users the permissions they need to subscribe to topics in your event domain. These roles are focused on event subscriptions and don't grant access for actions such as creating topics.

The Event Grid Contributor role allows you to create and manage Event Grid resources.

#### Permissions for event subscriptions

If you're using an event handler that isn't a WebHook (such as an event hub or queue storage), you need write access to that resource. This permissions check prevents an unauthorized user from sending events to your resource.

You must have the **Microsoft.EventGrid/EventSubscriptions/Write** permission on the resource that is the event source. You need this permission because you're writing a new subscription at the scope of the resource. The required resource differs based on whether you're subscribing to a system topic or custom topic. Both types are described in this section.

| Topic Type    | Description                                                                                                                                                                                                                                                               |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| System topics | Need permission to write a new event subscription at the scope of the resource publishing the event. The format of the resource is: `/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider}/{resource-type}/{resource-name}` |
| Custom topics | Need permission to write a new event subscription at the scope of the event grid topic. The format of the resource is: `/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.EventGrid/topics/{topic-name}`                          |
### Receive events by using webhooks

Webhooks are one of the many ways to receive events from Azure Event Grid. When a new event is ready, Event Grid service POSTs an HTTP request to the configured endpoint with the event in the request body.

Like many other services that support webhooks, Event Grid requires you to prove ownership of your Webhook endpoint before it starts delivering events to that endpoint. This requirement prevents a malicious user from flooding your endpoint with events.

When you use any of the following three Azure services, the Azure infrastructure automatically handles this validation:

- Azure Logic Apps with Event Grid Connector
- Azure Automation via webhook
- Azure Functions with Event Grid Trigger

#### Endpoint validation with Event Grid events

If you're using any other type of endpoint, such as an HTTP trigger based Azure function, your endpoint code needs to participate in a validation handshake with Event Grid. Event Grid supports two ways of validating the subscription.

- **Synchronous handshake**: At the time of event subscription creation, Event Grid sends a subscription validation event to your endpoint. The schema of this event is similar to any other Event Grid event. The data portion of this event includes a `validationCode` property. Your application verifies that the validation request is for an expected event subscription, and returns the validation code in the response synchronously. This handshake mechanism is supported in all Event Grid versions.
- **Asynchronous handshake**: In certain cases, you can't return the ValidationCode in response synchronously. For example, if you use a third-party service (like [Zapier](https://zapier.com/) or [IFTTT](https://ifttt.com/)), you can't programmatically respond with the validation code.

Starting with version 2018-05-01-preview, Event Grid supports a manual validation handshake. If you're creating an event subscription with an SDK or tool that uses API version 2018-05-01-preview or later, Event Grid sends a `validationUrl` property in the data portion of the subscription validation event. To complete the handshake, find that URL in the event data and do a GET request to it. You can use either a REST client or your web browser.

The provided URL is valid for **5 minutes**. During that time, the provisioning state of the event subscription is `AwaitingManualAction`. If you don't complete the manual validation within 5 minutes, the provisioning state is set to `Failed`. You have to create the event subscription again before starting the manual validation.

This authentication mechanism also requires the webhook endpoint to return an HTTP status code of 200 so that it knows that the POST for the validation event was accepted before it can be put in the manual validation mode. In other words, if the endpoint returns 200 but doesn't return back a validation response synchronously, the mode is transitioned to the manual validation mode. If there's a GET on the validation URL within 5 minutes, the validation handshake is considered to be successful.

![An image](../../Assets/Pasted image 20240824190024.png)

### Filter Events

When creating an event subscription, you have three options for filtering:

- Event types
- Subject begins with or ends with
- Advanced fields and operators

#### Event type filtering

By default, all event types for the event source are sent to the endpoint. You can decide to send only certain event types to your endpoint. For example, you can get notified of updates to your resources, but not notified for other operations like deletions. In that case, filter by the `Microsoft.Resources.ResourceWriteSuccess` event type. Provide an array with the event types, or specify `All` to get all event types for the event source.

The JSON syntax for filtering by event type is:

```JSON
"filter": {
	"includedEventTypes": [
	    "Microsoft.Resources.ResourceWriteFailure",
	    "Microsoft.Resources.ResourceWriteSuccess"
  ]
}
```

#### Subject filtering

For simple filtering by subject, specify a starting or ending value for the subject. For example, you can specify the subject ends with `.txt` to only get events related to uploading a text file to storage account. Or, you can filter the subject begins with `/blobServices/default/containers/testcontainer` to get all events for that container but not other containers in the storage account.

The JSON syntax for filtering by subject is:


```JSON
"filter": {
  "subjectBeginsWith": "/blobServices/default/containers/mycontainer/log",
  "subjectEndsWith": ".jpg"
}
```

#### Advanced filtering

To filter by values in the data fields and specify the comparison operator, use the advanced filtering option. In advanced filtering, you specify the:

- operator type - The type of comparison.
- key - The field in the event data that you're using for filtering. It can be a number, boolean, or string.
- value or values - The value or values to compare to the key.

The JSON syntax for using advanced filters is:

```JSON
"filter": {
  "advancedFilters": [
    {
      "operatorType": "NumberGreaterThanOrEquals",
      "key": "Data.Key1",
      "value": 5
    },
    {
      "operatorType": "StringContains",
      "key": "Subject",
      "values": ["container1", "container2"]
    }
  ]
}
```


## Explore Azure Event Hubs

Azure Event Hubs is a big data streaming platform and event ingestion service. It can receive and process millions of events per second. Data sent to an event hub can be transformed and stored by using any real-time analytics provider or batching/storage adapters.

After completing this module, you'll be able to:

- Describe the benefits of using Event Hubs and how it captures streaming data.
- Explain how to process events.
- Perform common operations with the Event Hubs client library.

Azure Event Hubs is a native data-streaming service in the cloud that can stream millions of events per second, with low latency, from any source to any destination. Event Hubs is compatible with Apache Kafka. It enables you to run existing Kafka workloads without any code changes.

With Event Hubs, you can ingest, buffer, store, and process your stream in real time to get actionable insights. Event Hubs uses a partitioned consumer model. It enables multiple applications to process the stream concurrently and lets you control the speed of processing. Event Hubs also integrates with Azure Functions for serverless architectures.

A broad ecosystem is available for the industry-standard AMQP 1.0 protocol. SDKs are available in languages like .NET, Java, Python, and JavaScript, so you can start processing your streams from Event Hubs. All supported client languages provide low-level integration.

### Key capabilities

Learn about the key capabilities of Azure Event Hubs in the following sections.
#### Apache Kafka on Azure Event Hubs

Event Hubs is a multi-protocol event streaming engine that natively supports Advanced Message Queuing Protocol (AMQP), Apache Kafka, and HTTPS protocols. Because it supports Apache Kafka, you can bring Kafka workloads to Event Hubs without making any code changes. You don't need to set up, configure, or manage your own Kafka clusters or use a Kafka-as-a-service offering that's not native to Azure.
#### Schema Registry in Event Hubs

Azure Schema Registry in Event Hubs provides a centralized repository for managing schemas of event streaming applications. Schema Registry comes free with every Event Hubs namespace. It integrates with your Kafka applications or Event Hubs SDK-based applications.
#### Real-time processing of streaming events with Stream Analytics

Event Hubs integrates with Azure Stream Analytics to enable real-time stream processing. With the built-in no-code editor, you can develop a Stream Analytics job by using drag-and-drop functionality, without writing any code.

Alternatively, developers can use the SQL-based Stream Analytics query language to perform real-time stream processing and take advantage of a wide range of functions for analyzing streaming data.
### Key concepts

Event Hubs contains the following key components:

- **Producer applications**: These applications can ingest data to an event hub by using Event Hubs SDKs or any Kafka producer client.
- **Namespace**: The management container for one or more event hubs or Kafka topics. The management tasks such as allocating streaming capacity, configuring network security, and enabling geo-disaster recovery are handled at the namespace level.
- **Event Hubs/Kafka topic**: In Event Hubs, you can organize events into an event hub or a Kafka topic. It's an append-only distributed log, which can comprise one or more partitions.
- **Partitions**: They're used to scale an event hub. They're like lanes in a freeway. If you need more streaming throughput, you can add more partitions.
- **Consumer applications**: These applications can consume data by seeking through the event log and maintaining consumer offset. Consumers can be Kafka consumer clients or Event Hubs SDK clients.
- **Consumer group**: This logical group of consumer instances reads data from an event hub or Kafka topic. It enables multiple consumers to read the same streaming data in an event hub independently at their own pace and with their own offsets.

### Explore Event Hubs Capture

Azure Event Hubs enables you to automatically capture the streaming data in Event Hubs in an Azure Blob storage or Azure Data Lake Storage account of your choice, with the added flexibility of specifying a time or size interval. Setting up Capture is fast, there are no administrative costs to run it, and it scales automatically with Event Hubs throughput units in the standard tier or processing units in the premium tier.

![Image showing capturing of Event Hubs data into Azure Storage or Azure Data Lake Storage](https://learn.microsoft.com/en-gb/training/wwl-azure/azure-event-hubs/media/event-hubs-capture.png)

Event Hubs Capture enables you to process real-time and batch-based pipelines on the same stream. This means you can build solutions that grow with your needs over time.

#### How Event Hubs Capture works

Event Hubs is a time-retention durable buffer for telemetry ingress, similar to a distributed log. The key to scaling in Event Hubs is the partitioned consumer model. Each partition is an independent segment of data and is consumed independently. Over time this data ages off, based on the configurable retention period. As a result, a given event hub never gets "too full."

Event Hubs Capture enables you to specify your own Azure Blob storage account and container, or Azure Data Lake Store account, which are used to store the captured data. These accounts can be in the same region as your event hub or in another region, adding to the flexibility of the Event Hubs Capture feature.

Captured data is written in Apache Avro format: a compact, fast, binary format that provides rich data structures with inline schema. This format is widely used in the Hadoop ecosystem, Stream Analytics, and Azure Data Factory. More information about working with Avro is available later in this article.

#### Capture windowing

Event Hubs Capture enables you to set up a window to control capturing. This window is a minimum size and time configuration with a "first wins policy," meaning that the first trigger encountered causes a capture operation. Each partition captures independently and writes a completed block blob at the time of capture, named for the time at which the capture interval was encountered. The storage naming convention is as follows:

```
{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}
```

Note the date values are padded with zeroes; an example filename might be:

```
https://mystorageaccount.blob.core.windows.net/mycontainer/mynamespace/myeventhub/0/2017/12/08/03/03/17.avro
```

#### Scaling to throughput units

Event Hubs traffic is controlled by throughput units. A single throughput unit allows 1 MB per second or 1,000 events per second of ingress and twice that amount of egress. Standard Event Hubs can be configured with 1-20 throughput units, and you can purchase more with a quota increase support request. Usage beyond your purchased throughput units is throttled. Event Hubs Capture copies data directly from the internal Event Hubs storage, bypassing throughput unit egress quotas and saving your egress for other processing readers, such as Stream Analytics or Spark.

Once configured, Event Hubs Capture runs automatically when you send your first event, and continues running. To make it easier for your downstream processing to know that the process is working, Event Hubs writes empty files when there's no data. This process provides a predictable cadence and marker that can feed your batch processors.

### Scale your processing application

To scale your event processing application, you can run multiple instances of the application and have it balance the load among themselves. In the older versions, **EventProcessorHost** allowed you to balance the load between multiple instances of your program and checkpoint events when receiving. In the newer versions (5.0 onwards), **EventProcessorClient** (.NET and Java), or **EventHubConsumerClient** (Python and JavaScript) allows you to do the same.

![An image](../../Assets/Pasted image 20240824191529.png)

#### Example scenario

As an example scenario, consider a home security company that monitors 100,000 homes. Every minute, it gets data from various sensors such as a motion detector, door/window open sensor, glass break detector, and so on, installed in each home. The company provides a web site for residents to monitor the activity of their home in near real time.

Each sensor pushes data to an event hub. The event hub is configured with 16 partitions. On the consuming end, you need a mechanism that can read these events, consolidate them, and dump the aggregate to a storage blob, which is then projected to a user-friendly web page.

When designing the consumer in a distributed environment, the scenario must handle the following requirements:

- **Scale:** Create multiple consumers, with each consumer taking ownership of reading from a few Event Hubs partitions.
- **Load balance:** Increase or reduce the consumers dynamically. For example, when a new sensor type (for example, a carbon monoxide detector) is added to each home, the number of events increases. In that case, the operator (a human) increases the number of consumer instances. Then, the pool of consumers can rebalance the number of partitions they own, to share the load with the newly added consumers.
- **Seamless resume on failures:** If a consumer (**consumer A**) fails (for example, the virtual machine hosting the consumer suddenly crashes), then other consumers can pick up the partitions owned by **consumer A** and continue. Also, the continuation point, called a _checkpoint_ or _offset_, should be at the exact point at which **consumer A** failed, or slightly before that.
- **Consume events:** While the previous three points deal with the management of the consumer, there must be code to consume the events and do something useful with it. For example, aggregate it and upload it to blob storage.

#### Event processor or consumer client

You don't need to build your own solution to meet these requirements. The Azure Event Hubs SDKs provide this functionality. In .NET or Java SDKs, you use an event processor client (`EventProcessorClient`), and in Python and JavaScript SDKs, you use `EventHubConsumerClient`.

For most production scenarios, we recommend that you use the event processor client for reading and processing events. Event processor clients can work cooperatively within the context of a consumer group for a given event hub. Clients will automatically manage distribution and balancing of work as instances become available or unavailable for the group.

#### Partition ownership tracking

An event processor instance typically owns and processes events from one or more partitions. Ownership of partitions is evenly distributed among all the active event processor instances associated with an event hub and consumer group combination.

Each event processor is given a unique identifier and claims ownership of partitions by adding or updating an entry in a checkpoint store. All event processor instances communicate with this store periodically to update its own processing state and to learn about other active instances. This data is then used to balance the load among the active processors.

#### Receive messages

When you create an event processor, you specify the functions that process events and errors. Each call to the function that processes events delivers a single event from a specific partition. It's your responsibility to handle this event. If you want to make sure the consumer processes every message at least once, you need to write your own code with retry logic. But be cautious about poisoned messages.

We recommend that you do things relatively fast. That is, do as little processing as possible. If you need to write to storage and do some routing, it's better to use two consumer groups and have two event processors.

#### Checkpointing

_Checkpointing_ is a process by which an event processor marks or commits the position of the last successfully processed event within a partition. Marking a checkpoint is typically done within the function that processes the events and occurs on a per-partition basis within a consumer group.

If an event processor disconnects from a partition, another instance can resume processing the partition at the checkpoint that was previously committed by the last processor of that partition in that consumer group. When the processor connects, it passes the offset to the event hub to specify the location at which to start reading. In this way, you can use checkpointing to both mark events as "complete" by downstream applications and to provide resiliency when an event processor goes down. It's possible to return to older data by specifying a lower offset from this checkpointing process.

#### Thread safety and processor instances

By default, the function that processes the events is called sequentially for a given partition. Subsequent events and calls to this function from the same partition queue up behind the scenes as the event pump continues to run in the background on other threads. Events from different partitions can be processed concurrently and any shared state that is accessed across partitions have to be synchronized.

### Control access to events

Azure Event Hubs supports both Microsoft Entra ID and shared access signatures (SAS) to handle both authentication and authorization. Azure provides the following Azure built-in roles for authorizing access to Event Hubs data using Microsoft Entra ID and OAuth:

- [Azure Event Hubs Data Owner](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#azure-event-hubs-data-owner): Use this role to give _complete access_ to Event Hubs resources.
- [Azure Event Hubs Data Sender](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#azure-event-hubs-data-sender): Use this role to give _send access_ to Event Hubs resources.
- [Azure Event Hubs Data Receiver](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#azure-event-hubs-data-receiver): Use this role to give _receiving access_ to Event Hubs resources.

#### Authorize access with managed identities

To authorize a request to Event Hubs service from a managed identity in your application, you need to configure Azure role-based access control settings for that managed identity. Azure Event Hubs defines Azure roles that encompass permissions for sending and reading from Event Hubs. When the Azure role is assigned to a managed identity, the managed identity is granted access to Event Hubs data at the appropriate scope.

#### Authorize access with Microsoft identity platform

A key advantage of using Microsoft Entra ID with Event Hubs is that your credentials no longer need to be stored in your code. Instead, you can request an OAuth 2.0 access token from Microsoft identity platform. Microsoft Entra authenticates the security principal (a user, a group, or service principal) running the application. If authentication succeeds, Microsoft Entra ID returns the access token to the application, and the application can then use the access token to authorize requests to Azure Event Hubs.

#### Authorize access to Event Hubs publishers with shared access signatures

An event publisher defines a virtual endpoint for an Event Hubs. The publisher can only be used to send messages to an event hub and not receive messages. Typically, an event hub employs one publisher per client. All messages that are sent to any of the publishers of an event hub are enqueued within that event hub. Publishers enable fine-grained access control.

Each Event Hubs client is assigned a unique token that is uploaded to the client. A client that holds a token can only send to one publisher, and no other publisher. If multiple clients share the same token, then each of them shares the publisher.

All tokens are assigned with shared access signature keys. Typically, all tokens are signed with the same key. Clients aren't aware of the key, which prevents clients from manufacturing tokens. Clients operate on the same tokens until they expire.

#### Authorize access to Event Hubs consumers with shared access signatures

To authenticate back-end applications that consume from the data generated by Event Hubs producers, Event Hubs token authentication requires its clients to either have the **manage** rights or the **listen** privileges assigned to its Event Hubs namespace or event hub instance or topic. Data is consumed from Event Hubs using consumer groups. While SAS policy gives you granular scope, this scope is defined only at the entity level and not at the consumer level. It means that the privileges defined at the namespace level or the event hub instance or topic level are to the consumer groups of that entity.

### Perform common operations with the Event Hubs client library

This unit contains examples of common operations you can perform with the Event Hubs client library (`Azure.Messaging.EventHubs`) to interact with an Event Hubs.

#### Inspect Event Hubs

Many Event Hubs operations take place within the scope of a specific partition. Because Event Hubs owns the partitions, their names are assigned at the time of creation. To understand what partitions are available, you query the Event Hubs using one of the Event Hubs clients. For illustration, the `EventHubProducerClient` is demonstrated in these examples, but the concept and form are common across clients.

```C#
var connectionString = "<< CONNECTION STRING FOR THE EVENT HUBS NAMESPACE >>";
var eventHubName = "<< NAME OF THE EVENT HUB >>";

await using (var producer = new EventHubProducerClient(connectionString, eventHubName))
{
    string[] partitionIds = await producer.GetPartitionIdsAsync();
}
```

#### Publish events to Event Hubs

In order to publish events, you need to create an `EventHubProducerClient`. Producers publish events in batches and might request a specific partition, or allow the Event Hubs service to decide which partition events should be published to. We recommended using automatic routing when the publishing of events needs to be highly available or when event data should be distributed evenly among the partitions. Our example takes advantage of automatic routing.


```C#
var connectionString = "<< CONNECTION STRING FOR THE EVENT HUBS NAMESPACE >>";
var eventHubName = "<< NAME OF THE EVENT HUB >>";

await using (var producer = new EventHubProducerClient(connectionString, eventHubName))
{
    using EventDataBatch eventBatch = await producer.CreateBatchAsync();
    eventBatch.TryAdd(new EventData(new BinaryData("First")));
    eventBatch.TryAdd(new EventData(new BinaryData("Second")));

    await producer.SendAsync(eventBatch);
}
```

#### Read events from an Event Hubs

In order to read events from an Event Hubs, you need to create an `EventHubConsumerClient` for a given consumer group. When an Event Hubs is created, it provides a default consumer group that can be used to get started with exploring Event Hubs. In our example, we focus on reading all events published to the Event Hubs using an iterator.

![An image](../../Assets/Pasted image 20240824192611.png)

```C#
var connectionString = "<< CONNECTION STRING FOR THE EVENT HUBS NAMESPACE >>";
var eventHubName = "<< NAME OF THE EVENT HUB >>";

string consumerGroup = EventHubConsumerClient.DefaultConsumerGroupName;

await using (var consumer = new EventHubConsumerClient(consumerGroup, connectionString, eventHubName))
{
    using var cancellationSource = new CancellationTokenSource();
    cancellationSource.CancelAfter(TimeSpan.FromSeconds(45));

    await foreach (PartitionEvent receivedEvent in consumer.ReadEventsAsync(cancellationSource.Token))
    {
        // At this point, the loop will wait for events to be available in the Event Hub. When an event
        // is available, the loop will iterate with the event that was received. Because we did not
        // specify a maximum wait time, the loop will wait forever unless cancellation is requested using
        // the cancellation token.
    }
}
```

#### Read events from an Event Hubs partition

To read from a specific partition, the consumer needs to specify where in the event stream to begin receiving events. In our example, we focus on reading all published events for the first partition of the Event Hubs.

```C#
var connectionString = "<< CONNECTION STRING FOR THE EVENT HUBS NAMESPACE >>";
var eventHubName = "<< NAME OF THE EVENT HUB >>";

string consumerGroup = EventHubConsumerClient.DefaultConsumerGroupName;

await using (var consumer = new EventHubConsumerClient(consumerGroup, connectionString, eventHubName))
{
    EventPosition startingPosition = EventPosition.Earliest;
    string partitionId = (await consumer.GetPartitionIdsAsync()).First();

    using var cancellationSource = new CancellationTokenSource();
    cancellationSource.CancelAfter(TimeSpan.FromSeconds(45));

    await foreach (PartitionEvent receivedEvent in consumer.ReadEventsFromPartitionAsync(partitionId, startingPosition, cancellationSource.Token))
    {
        // At this point, the loop will wait for events to be available in the partition. When an event
        // is available, the loop will iterate with the event that was received. Because we did not
        // specify a maximum wait time, the loop will wait forever unless cancellation is requested using
        // the cancellation token.
    }
}
```

#### Process events using an Event Processor client

For most production scenarios, the recommendation is to use `EventProcessorClient` for reading and processing events. Since the `EventProcessorClient` has a dependency on Azure Storage blobs for persistence of its state, you need to provide a `BlobContainerClient` for the processor, which has been configured for the storage account and container that should be used.

```C#
var cancellationSource = new CancellationTokenSource();
cancellationSource.CancelAfter(TimeSpan.FromSeconds(45));

var storageConnectionString = "<< CONNECTION STRING FOR THE STORAGE ACCOUNT >>";
var blobContainerName = "<< NAME OF THE BLOB CONTAINER >>";

var eventHubsConnectionString = "<< CONNECTION STRING FOR THE EVENT HUBS NAMESPACE >>";
var eventHubName = "<< NAME OF THE EVENT HUB >>";
var consumerGroup = "<< NAME OF THE EVENT HUB CONSUMER GROUP >>";

Task processEventHandler(ProcessEventArgs eventArgs) => Task.CompletedTask;
Task processErrorHandler(ProcessErrorEventArgs eventArgs) => Task.CompletedTask;

var storageClient = new BlobContainerClient(storageConnectionString, blobContainerName);
var processor = new EventProcessorClient(storageClient, consumerGroup, eventHubsConnectionString, eventHubName);

processor.ProcessEventAsync += processEventHandler;
processor.ProcessErrorAsync += processErrorHandler;

await processor.StartProcessingAsync();

try
{
    // The processor performs its work in the background; block until cancellation
    // to allow processing to take place.

    await Task.Delay(Timeout.Infinite, cancellationSource.Token);
}
catch (TaskCanceledException)
{
    // This is expected when the delay is canceled.
}

try
{
    await processor.StopProcessingAsync();
}
finally
{
    // To prevent leaks, the handlers should be removed when processing is complete.

    processor.ProcessEventAsync -= processEventHandler;
    processor.ProcessErrorAsync -= processErrorHandler;
}
```