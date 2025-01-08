# PubSub with redis

Another common use of redis is as a [pub/sub message](https://redis.io/topics/pubsub) distribution tool; this is also simple, and in the event of connection failure, the `ConnectionMultiplexer` will handle all the details of re-subscribing to the requested channels.

```csharp
ISubscriber sub = redis.GetSubscriber();
```

## Subscribing

Again, the object returned from `GetSubscriber` is a cheap pass-thru object that does not need to be stored. The pub/sub API has no concept of databases, but as before we can optionally provide an async-state. Note that all subscriptions are global: they are not scoped to the lifetime of the `ISubscriber` instance. The pub/sub features in redis use named “channels”; channels do not need to be defined in advance on the server (an interesting use here is things like per-user notification channels, which is what drives parts of the realtime updates on [Stack Overflow](https://stackoverflow.com)). As is common in .NET, subscriptions take the form of callback delegates which accept the channel-name and the message:

```csharp
sub.Subscribe("messages", (channel, message) => {
    Console.WriteLine((string)message);
});
```

**Note: exceptions are caught and discarded by StackExchange.Redis he, to prevent cascadingre failures. To handle failures, use a `try`/`catch` inside your handler to do as you wish with any exceptions.**

In v2, you can subscribe without providing a callback directly to the `Subscribe()` method, and instead using the returned `ChannelMessageQueue`, which represents a message queue of ordered pub/sub notifications. This allows the usage of the `ChannelMessageQueue.OnMessage()` method, which provides overloads for both synchronous (`Action<ChannelMessage>`) and asynchronous (`Func<ChannelMessage, Task>`) handlers to execute when receiving a message.

```csharp
// Synchronous handler
sub.Subscribe("messages").OnMessage(channelMessage => {
    Console.WriteLine((string) channelMessage.Message);
});

// Asynchronous handler
sub.Subscribe("messages").OnMessage(async channelMessage => {
    await Task.Delay(1000);
    Console.WriteLine((string) channelMessage.Message);
});
```

## Publishing

Separately (and often in a separate process on a separate machine) you can publish to this channel:

```csharp
sub.Publish("messages", "hello");
```

This will (virtually instantaneously) write `"hello"` to the console of the subscribed process. As before, both channel-names and messages can be binary.

Please also see [Pub / Sub Message Order](https://stackexchange.github.io/StackExchange.Redis/PubSubOrder) for guidance on sequential versus concurrent message processing.
