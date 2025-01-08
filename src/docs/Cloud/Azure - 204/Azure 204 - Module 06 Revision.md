# Implement user authentication and authorization

## Explore the microsoft identity platform

- Identify the components of the Microsoft identity platform
- Describe the three types of service principals and how they relate to application objects
- Explain how permissions and user consent operate, and how conditional access impacts your application

The Microsoft identity platform for developers is a set of tools that includes authentication service, open-source libraries, and application management tools.

- **OAuth 2.0 and OpenID Connect standard-compliant authentication service** enabling developers to authenticate several identity types, including:
    - Work or school accounts, provisioned through Microsoft Entra ID
    - Personal Microsoft account, like Skype, Xbox, and Outlook.com
    - Social or local accounts, by using Azure Active Directory B2C
    - Social or local customer accounts, by using Microsoft Entra External ID
- **Open-source libraries**: Microsoft Authentication Libraries (MSAL) and support for other standards-compliant libraries
- **Microsoft identity platform endpoint**: Works with the Microsoft Authentication Libraries (MSAL) or any other standards-compliant library. It implements human readable scopes, in accordance with industry standards.
- **Application management portal**: A registration and configuration experience in the Azure portal, along with the other Azure management capabilities.
- **Application configuration API and PowerShell**: Programmatic configuration of your applications through the Microsoft Graph API and PowerShell so you can automate your DevOps tasks.

For developers, the Microsoft identity platform offers integration of modern innovations in the identity and security space like passwordless authentication, step-up authentication, and Conditional Access. You don’t need to implement such functionality yourself: applications integrated with the Microsoft identity platform natively take advantage of such innovations.

### Explore service principals

To delegate Identity and Access Management functions to Microsoft Entra ID, an application must be registered with a Microsoft Entra tenant. When you register your application with Microsoft Entra ID, you're creating an identity configuration for your application that allows it to integrate with Microsoft Entra ID. When you register an app in the Azure portal, you choose whether it is:

- **Single tenant**: only accessible in your tenant
- **Multi-tenant**: accessible in other tenants

If you register an application in the portal, an application object (the globally unique instance of the app) and a service principal object are automatically created in your home tenant. You also have a globally unique ID for your app (the app or client ID). In the portal, you can then add secrets or certificates and scopes to make your app work, customize the branding of your app in the sign-in dialog, and more.

#### Application object

A Microsoft Entra application is scoped to its one and only application object. The application object resides in the Microsoft Entra tenant where the application was registered (known as the application's "home" tenant). An application object is used as a template or blueprint to create one or more service principal objects. A service principal is created in every tenant where the application is used. Similar to a class in object-oriented programming, the application object has some static properties that are applied to all the created service principals (or application instances).

The application object describes three aspects of an application:

- How the service can issue tokens in order to access the application.
- Resources that the application might need to access.
- The actions that the application can take.

#### Service principal object

There are three types of service principal:

- **Application** - This type of service principal is the local representation, or application instance, of a global application object in a single tenant or directory. A service principal is created in each tenant where the application is used, and references the globally unique app object. The service principal object defines what the app can actually do in the specific tenant, who can access the app, and what resources the app can access.
- **Managed identity** - This type of service principal is used to represent a [managed identity](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview). Managed identities provide an identity for applications to use when connecting to resources that support Microsoft Entra authentication. When a managed identity is enabled, a service principal representing that managed identity is created in your tenant. Service principals representing managed identities can be granted access and permissions, but can't be updated or modified directly.
- **Legacy** - This type of service principal represents a legacy app, which is an app created before app registrations were introduced or an app created through legacy experiences. A legacy service principal can have:
    - credentials
    - service principal names
    - reply URLs
    - and other properties that an authorized user can edit, but doesn't have an associated app registration.

#### Relationship between application objects and service principals

The application object is the _global_ representation of your application for use across all tenants, and the service principal is the _local_ representation for use in a specific tenant. The application object serves as the template from which common and default properties are _derived_ for use in creating corresponding service principal objects.

An application object has:

- A one to one relationship with the software application, and
- A one to many relationships with its corresponding service principal objects.

A service principal must be created in each tenant where the application is used to establish an identity for sign-in and/or access to resources being secured by the tenant. A single-tenant application has only one service principal (in its home tenant), created and consented for use during application registration. A multi-tenant application also has a service principal created in each tenant where a user from that tenant consented to its use.

### Discover permissions and consent

The Microsoft identity platform implements the [OAuth 2.0](https://learn.microsoft.com/en-us/azure/active-directory/develop/active-directory-v2-protocols) authorization protocol. OAuth 2.0 is a method through which a third-party app can access web-hosted resources on behalf of a user. Any web-hosted resource that integrates with the Microsoft identity platform has a resource identifier, or _application ID URI_.

Here are some examples of Microsoft web-hosted resources:

- Microsoft Graph: `https://graph.microsoft.com`
- Microsoft 365 Mail API: `https://outlook.office.com`
- Azure Key Vault: `https://vault.azure.net`

The same is true for any third-party resources that are integrated with the Microsoft identity platform. Any of these resources also can define a set of permissions that can be used to divide the functionality of that resource into smaller chunks. When a resource's functionality is chunked into small permission sets, third-party apps can be built to request only the permissions that they need to perform their function. Users and administrators can know what data the app can access.

In OAuth 2.0, these types of permission sets are called _scopes_. They're also often referred to as _permissions_. In the Microsoft identity platform, a permission is represented as a string value. An app requests the permissions it needs by specifying the permission in the `scope` query parameter. Identity platform supports several well-defined [OpenID Connect scopes](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent#openid-connect-scopes) and resource-based permissions (each permission is indicated by appending the permission value to the resource's identifier or application ID URI). For example, the permission string `https://graph.microsoft.com/Calendars.Read` is used to request permission to read users calendars in Microsoft Graph.

An app most commonly requests these permissions by specifying the scopes in requests to the Microsoft identity platform authorize endpoint. However, some high-privilege permissions can be granted only through administrator consent. They can be requested or granted by using the [administrator consent endpoint](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent#admin-restricted-permissions)

#### Permission types

The Microsoft identity platform supports two types of permissions: _delegated access_ and _app-only access_.

- **Delegated access** are used by apps that have a signed-in user present. For these apps, either the user or an administrator consents to the permissions that the app requests. The app is delegated with the permission to act as a signed-in user when it makes calls to the target resource.
- **App-only access permissions** are used by apps that run without a signed-in user present, for example, apps that run as background services or daemons. Only an administrator can consent to app-only access permissions.

#### Consent types

Applications in Microsoft identity platform rely on consent in order to gain access to necessary resources or APIs. There are many kinds of consent that your app might need to know about in order to be successful. If you're defining permissions, you'll also need to understand how your users gain access to your app or API.

There are three consent types: _static user consent_, _incremental and dynamic user consent_, and _admin consent_.

##### Static user consent

In the static user consent scenario, you must specify all the permissions it needs in the app's configuration in the Azure portal. If the user (or administrator, as appropriate) hasn't granted consent for this app, then Microsoft identity platform prompts the user to provide consent at this time. Static permissions also enable administrators to consent on behalf of all users in the organization.

While static permissions of the app defined in the Azure portal keep the code nice and simple, it presents some possible issues for developers:

- The app needs to request all the permissions it would ever need upon the user's first sign-in. This can lead to a long list of permissions that discourages end users from approving the app's access on initial sign-in.
- The app needs to know all of the resources it would ever access ahead of time. It's difficult to create apps that could access an arbitrary number of resources.

##### Incremental and dynamic user consent

With the Microsoft identity platform endpoint, you can ignore the static permissions defined in the app registration information in the Azure portal and request permissions incrementally instead. You can ask for a minimum set of permissions upfront and request more over time as the customer uses more app features.

To do so, you can specify the scopes your app needs at any time by including the new scopes in the `scope` parameter when requesting an access token - without the need to predefine them in the application registration information. If the user hasn't yet consented to new scopes added to the request, they're prompted to consent only to the new permissions. Incremental, or dynamic consent, only applies to delegated permissions and not to app-only access permissions.

![An image](../../Assets/Pasted image 20240819094856.png)

##### Admin consent

Admin consent is required when your app needs access to certain high-privilege permissions. Admin consent ensures that administrators have some other controls before authorizing apps or users to access highly privileged data from the organization.

Admin consent done on behalf of an organization still requires the static permissions registered for the app. Set those permissions for apps in the app registration portal if you need an admin to give consent on behalf of the entire organization. This reduces the cycles required by the organization admin to set up the application.

#### Requesting individual user consent

In an OpenID Connect or OAuth 2.0 authorization request, an app can request the permissions it needs by using the scope query parameter. For example, when a user signs in to an app, the app sends a request like the following example. Line breaks are added for legibility.

```
GET https://login.microsoftonline.com/common/oauth2/v2.0/authorize?
client_id=6731de76-14a6-49ae-97bc-6eba6914391e
&response_type=code
&redirect_uri=http%3A%2F%2Flocalhost%2Fmyapp%2F
&response_mode=query
&scope=
https%3A%2F%2Fgraph.microsoft.com%2Fcalendars.read%20
https%3A%2F%2Fgraph.microsoft.com%2Fmail.send
```

The `scope` parameter is a space-separated list of delegated permissions that the app is requesting. Each permission is indicated by appending the permission value to the resource's identifier (the application ID URI). In the request example, the app needs permission to read the user's calendar and send mail as the user.

After the user enters their credentials, the Microsoft identity platform checks for a matching record of _user consent_. If the user hasn't consented to any of the requested permissions in the past, and if the administrator hasn't consented to these permissions on behalf of the entire organization, the Microsoft identity platform asks the user to grant the requested permissions.

### Discover conditional access

The Conditional Access feature in Microsoft Entra ID offers one of several ways that you can use to secure your app and protect a service. Conditional Access enables developers and enterprise customers to protect services in a multitude of ways including:

- [Multifactor authentication](https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-mfa-howitworks)
- Allowing only Intune enrolled devices to access specific services
- Restricting user locations and IP ranges

#### How does Conditional Access impact an app?

In most common cases, Conditional Access doesn't change an app's behavior or require any changes from the developer. Only in certain cases when an app indirectly or silently requests a token for a service does an app require code changes to handle Conditional Access challenges. It may be as simple as performing an interactive sign-in request.

Specifically, the following scenarios require code to handle Conditional Access challenges:

- Apps performing the on-behalf-of flow
- Apps accessing multiple services/resources
- Single-page apps using MSAL.js
- Web apps calling a resource

Conditional Access policies can be applied to the app and also a web API your app accesses. Depending on the scenario, an enterprise customer can apply and remove Conditional Access policies at any time. For your app to continue functioning when a new policy is applied, implement challenge handling.

#### Conditional Access examples

Some scenarios require code changes to handle Conditional Access whereas others work as is. Here are a few scenarios using Conditional Access to do multi-factor authentication that gives some insight into the difference.

- You're building a single-tenant iOS app and apply a Conditional Access policy. The app signs in a user and doesn't request access to an API. When the user signs in, the policy is automatically invoked and the user needs to perform multi-factor authentication.
- You're building an app that uses a middle tier service to access a downstream API. An enterprise customer at the company using this app applies a policy to the downstream API. When an end user signs in, the app requests access to the middle tier and sends the token. The middle tier performs on-behalf-of flow to request access to the downstream API. At this point, a claims "challenge" is presented to the middle tier. The middle tier sends the challenge back to the app, which needs to comply with the Conditional Access policy.

## Implement authentication by using the Microsoft Authentication Library

- Explain the benefits of using MSAL and the application types and scenarios it supports
- Instantiate both public and confidential client apps from code
- Register an app with the Microsoft identity platform
- Create an app that retrieves a token by using the MSAL.NET library

### Explore the Microsoft Authentication Library

MSAL gives you many ways to get tokens, with a consistent API for many platforms. Using MSAL provides the following benefits:

- No need to directly use the OAuth libraries or code against the protocol in your application.
- Acquires tokens on behalf of a user or on behalf of an application (when applicable to the platform).
- Maintains a token cache and refreshes tokens for you when they're close to expire. You don't need to handle token expiration on your own.
- Helps you specify which audience you want your application to sign in.
- Helps you set up your application from configuration files.
- Helps you troubleshoot your app by exposing actionable exceptions, logging, and telemetry.

### Application types and scenarios

Within MSAL, a token can be acquired from many application types: web applications, web APIs, single-page apps (JavaScript), mobile and native applications, and daemons and server-side applications. MSAL currently supports the platforms and frameworks listed in the following table.

| Library                                                                                                      | Supported platforms and frameworks                                                               |
| ------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| [MSAL for Android](https://github.com/AzureAD/microsoft-authentication-library-for-android)                  | Android                                                                                          |
| [MSAL Angular](https://github.com/AzureAD/microsoft-authentication-library-for-js/tree/dev/lib/msal-angular) | Single-page apps with Angular and Angular.js frameworks                                          |
| [MSAL for iOS and macOS](https://github.com/AzureAD/microsoft-authentication-library-for-objc)               | iOS and macOS                                                                                    |
| [MSAL Go (Preview)](https://github.com/AzureAD/microsoft-authentication-library-for-go)                      | Windows, macOS, Linux                                                                            |
| [MSAL Java](https://github.com/AzureAD/microsoft-authentication-library-for-java)                            | Windows, macOS, Linux                                                                            |
| [MSAL.js](https://github.com/AzureAD/microsoft-authentication-library-for-js/tree/dev/lib/msal-browser)      | JavaScript/TypeScript frameworks such as Vue.js, Ember.js, or Durandal.js                        |
| [MSAL.NET](https://github.com/AzureAD/microsoft-authentication-library-for-dotnet)                           | .NET Framework, .NET, .NET MAUI, WINUI, Xamarin Android, Xamarin iOS, Universal Windows Platform |
| [MSAL Node](https://github.com/AzureAD/microsoft-authentication-library-for-js/tree/dev/lib/msal-node)       | Web apps with Express, desktop apps with Electron, Cross-platform console apps                   |
| [MSAL Python](https://github.com/AzureAD/microsoft-authentication-library-for-python)                        | Windows, macOS, Linux                                                                            |
| [MSAL React](https://github.com/AzureAD/microsoft-authentication-library-for-js/tree/dev/lib/msal-react)     | Single-page apps with React and React-based libraries (Next.js, Gatsby.js)                       |
### Authentication flows

The following table shows some of the different authentication flows provided by Microsoft Authentication Library (MSAL). These flows can be used in various application scenarios.

| Authentication flow                     |                                                                                                                                                                                                  | Supported application types                                 |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------- |
| Authorization code                      | User sign-in and access to web APIs on behalf of the user.                                                                                                                                       | Desktop, Mobile, Single-page app (SPA) (requires PKCE), Web |
| Client credentials                      | Access to web APIs by using the identity of the application itself. Typically used for server-to-server communication and automated scripts requiring no user interaction.                       | Daemon                                                      |
| Device code                             | User sign-in and access to web APIs on behalf of the user on input-constrained devices like smart TVs and IoT devices. Also used by command line interface (CLI) applications.                   | Desktop, Mobile                                             |
| Implicit grant                          | User sign-in and access to web APIs on behalf of the user. _The implicit grant flow is no longer recommended - use authorization code with PKCE instead._                                        | Single-page app (SPA), Web                                  |
| On-behalf-of (OBO)                      | Access from an "upstream" web API to a "downstream" web API on behalf of the user. The user's identity and delegated permissions are passed through to the downstream API from the upstream API. | Web API                                                     |
| Username/password (ROPC)                | Allows an application to sign in the user by directly handling their password. _The ROPC flow is NOT recommended._                                                                               | Desktop, Mobile                                             |
| Integrated Windows authentication (IWA) | Allows applications on domain or Microsoft Entra joined computers to acquire a token silently (without any UI interaction from the user).                                                        | Desktop, Mobile                                             |
### Public client and confidential client applications

When examining the public or confidential nature of a given client, we're evaluating the ability of that client to prove its identity to the authorization server. This is important because the authorization server must be able to trust the identity of the client in order to issue access tokens.

- **Public client applications** run on devices, such as desktop, browserless APIs, mobile or client-side browser apps. They can't be trusted to safely keep application secrets, so they can only access web APIs on behalf of the user. Anytime the source, or compiled bytecode of a given app, is transmitted anywhere it can be read, disassembled, or otherwise inspected by untrusted parties. As they also only support public client flows and can't hold configuration-time secrets, they can't have client secrets.
- **Confidential client applications** run on servers, such as web apps, web API apps, or service/daemon apps. They're considered difficult to access by users or attackers, and therefore can adequately hold configuration-time secrets to assert proof of its identity. The client ID is exposed through the web browser, but the secret is passed only in the back channel and never directly exposed.

## Initialize client applications

With MSAL.NET 3.x, the recommended way to instantiate an application is by using the application builders: `PublicClientApplicationBuilder` and `ConfidentialClientApplicationBuilder`. They offer a powerful mechanism to configure the application either from the code, or from a configuration file, or even by mixing both approaches.

Before initializing an application, you first need to register it so that your app can be integrated with the Microsoft identity platform. After registration, you may need the following information (which can be found in the Azure portal):

- **Application (client) ID** - This is a string representing a GUID.
- **Directory (tenant) ID** - Provides identity and access management (IAM) capabilities to applications and resources used by your organization. It can specify if you're writing a line of business application solely for your organization (also named single-tenant application).
- The identity provider URL (named the **instance**) and the sign-in audience for your application. These two parameters are collectively known as the authority.
- **Client credentials** - which can take the form of an application secret (client secret string) or certificate (of type `X509Certificate2`) if it's a confidential client app.
- For web apps, and sometimes for public client apps (in particular when your app needs to use a broker), you need to set the **Redirect URI** where the identity provider will contact back your application with the security tokens.

### Initializing public and confidential client applications from code

The following code instantiates a public client application, signing-in users in the Microsoft Azure public cloud, with their work and school accounts, or their personal Microsoft accounts.

```C#
IPublicClientApplication app = PublicClientApplicationBuilder.Create(clientId).Build();
```

In the same way, the following code instantiates a confidential application (a Web app located at `https://myapp.azurewebsites.net`) handling tokens from users in the Microsoft Azure public cloud, with their work and school accounts, or their personal Microsoft accounts. The application is identified with the identity provider by sharing a client secret:

```C#
string redirectUri = "https://myapp.azurewebsites.net";
IConfidentialClientApplication app = ConfidentialClientApplicationBuilder.Create(clientId)
    .WithClientSecret(clientSecret)
    .WithRedirectUri(redirectUri )
    .Build();
```

### Builder modifiers

In the code snippets using application builders, `.With` methods can be applied as modifiers (for example, `.WithAuthority` and `.WithRedirectUri`).

- `.WithAuthority` modifier: The `.WithAuthority` modifier sets the application default authority to a Microsoft Entra authority, with the possibility of choosing the Azure Cloud, the audience, the tenant (tenant ID or domain name), or providing directly the authority URI.

```C#
IPublicClientApplication app;
app = PublicClientApplicationBuilder.Create(clientId)
    .WithAuthority(AzureCloudInstance.AzurePublic, tenantId)
    .Build();
```

- `.WithRedirectUri` modifier: The `.WithRedirectUri` modifier overrides the default redirect URI.

```C#
IPublicClientApplication app;
app = PublicClientApplicationBuilder.Create(client_id)
    .WithAuthority(AzureCloudInstance.AzurePublic, tenant_id)
    .WithRedirectUri("http://localhost")
    .Build();
```

### Modifiers common to public and confidential client applications

The table below lists some of the modifiers you can set on a public, or confidential client.

| Modifier                                              | Description                                                                                                                                                                                                            |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `.WithAuthority()`                                    | Sets the application default authority to a Microsoft Entra authority, with the possibility of choosing the Azure Cloud, the audience, the tenant (tenant ID or domain name), or providing directly the authority URI. |
| `.WithTenantId(string tenantId)`                      | Overrides the tenant ID, or the tenant description.                                                                                                                                                                    |
| `.WithClientId(string)`                               | Overrides the client ID.                                                                                                                                                                                               |
| `.WithRedirectUri(string redirectUri)`                | Overrides the default redirect URI. This is useful for scenarios requiring a broker.                                                                                                                                   |
| `.WithComponent(string)`                              | Sets the name of the library using MSAL.NET (for telemetry reasons).                                                                                                                                                   |
| `.WithDebugLoggingCallback()`                         | If called, the application calls `Debug.Write` simply enabling debugging traces.                                                                                                                                       |
| `.WithLogging()`                                      | If called, the application calls a callback with debugging traces.                                                                                                                                                     |
| `.WithTelemetry(TelemetryCallback telemetryCallback)` | Sets the delegate used to send telemetry.                                                                                                                                                                              |
### Modifiers specific to confidential client applications

The modifiers specific to a confidential client application builder can be found in the `ConfidentialClientApplicationBuilder` class. The different methods can be found in the [Azure SDK for .NET documentation](https://learn.microsoft.com/en-us/dotnet/api/microsoft.identity.client.confidentialclientapplicationbuilder).

Modifiers such as `.WithCertificate(X509Certificate2 certificate)` and `.WithClientSecret(string clientSecret)` are mutually exclusive. If you provide both, MSAL throws a meaningful exception.

## Implement interactive authentication by using MSAL.NET

In this exercise you learn how to perform the following actions:

- Register an application with the Microsoft identity platform
- Use the `PublicClientApplicationBuilder` class in MSAL.NET
- Acquire a token interactively in a console application

### Register a new application

- Sign in to the portal: [https://portal.azure.com](https://portal.azure.com)
- Search for and select **Microsoft Entra ID**.
- Under **Manage**, select **App registrations** > **New registration**.
- When the **Register an application** page appears, enter your application's registration information:

|Field|Value|
|---|---|
|**Name**|`az204appreg`|
|**Supported account types**|Select **Accounts in this organizational directory only**|
|**Redirect URI (optional)**|Select **Public client/native (mobile & desktop)** and enter `http://localhost` in the box to the right.|
- Select **Register**.

Microsoft Entra ID assigns a unique application (client) ID to your app, and you're taken to your application's **Overview** page.

### Set up the console application

```
md az204-auth
cd az204-auth
```

```
dotnet new console
```

```
code . -r
```

### Build the console app

#### Add packages and using statements

- Add the `Microsoft.Identity.Client` package to the project in a terminal in Visual Studio Code.

```
dotnet add package Microsoft.Identity.Client
```

- Open the _Program.cs_ file and add `using` statements to include `Microsoft.Identity.Client` and to enable async operations.

```C#
using System.Threading.Tasks;
using Microsoft.Identity.Client;
```

- Change the Main method to enable async.

```C#
public static async Task Main(string[] args)
```

#### Add code for the interactive authentication

- You need two variables to hold the Application (client) and Directory (tenant) IDs. You can copy those values from the portal. Add the following code and replace the string values with the appropriate values from the portal.

```C#
private const string _clientId = "APPLICATION_CLIENT_ID";
private const string _tenantId = "DIRECTORY_TENANT_ID";
```

- Use the `PublicClientApplicationBuilder` class to build out the authorization context.

```C#
var app = PublicClientApplicationBuilder
    .Create(_clientId)
    .WithAuthority(AzureCloudInstance.AzurePublic, _tenantId)
    .WithRedirectUri("http://localhost")
    .Build();
```

| Code             | Description                                                                                                                                            |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `.Create`        | Creates a `PublicClientApplicationBuilder` from a clientID.                                                                                            |
| `.WithAuthority` | Adds a known Authority corresponding to an ADFS server. In the code we're specifying the Public cloud, and using the tenant for the app we registered. |
#### Acquire a token

When you registered the _az204appreg_ app, it automatically generated an API permission `user.read` for Microsoft Graph. You use that permission to acquire a token.

- Set the permission scope for the token request. Add the following code below the `PublicClientApplicationBuilder`.

```C#
string[] scopes = { "user.read" };
```

- Add code to request the token and write the result out to the console.

```C#
AuthenticationResult result = await app.AcquireTokenInteractive(scopes).ExecuteAsync();

Console.WriteLine($"Token:\t{result.AccessToken}");
```

### Review completed application

The contents of the _Program.cs_ file should resemble the following example:

```C#
using System;
using System.Threading.Tasks;
using Microsoft.Identity.Client;

namespace az204_auth
{
    class Program
    {
        private const string _clientId = "APPLICATION_CLIENT_ID";
        private const string _tenantId = "DIRECTORY_TENANT_ID";

        public static async Task Main(string[] args)
        {
            var app = PublicClientApplicationBuilder
                .Create(_clientId)
                .WithAuthority(AzureCloudInstance.AzurePublic, _tenantId)
                .WithRedirectUri("http://localhost")
                .Build(); 
            string[] scopes = { "user.read" };
            AuthenticationResult result = await app.AcquireTokenInteractive(scopes).ExecuteAsync();

            Console.WriteLine($"Token:\t{result.AccessToken}");
        }
    }
}
```

## Implement shared access signatures

After completing this module, you'll be able to:

- Identify the three types of shared access signatures
- Explain when to implement shared access signatures
- Create a stored access policy

A shared access signature (SAS) is a signed URI that points to one or more storage resources and includes a token that contains a special set of query parameters. The token indicates how the resources might be accessed by the client. One of the query parameters, the signature, is constructed from the SAS parameters and signed with the key that was used to create the SAS. This signature is used by Azure Storage to authorize access to the storage resource.

### Types of shared access signatures

Azure Storage supports three types of shared access signatures:

- **User delegation SAS**: A user delegation SAS is secured with Microsoft Entra credentials and also by the permissions specified for the SAS. A user delegation SAS applies to Blob storage only.
- **Service SAS**: A service SAS is secured with the storage account key. A service SAS delegates access to a resource in the following Azure Storage services: Blob storage, Queue storage, Table storage, or Azure Files.
- **Account SAS**: An account SAS is secured with the storage account key. An account SAS delegates access to resources in one or more of the storage services. All of the operations available via a service or user delegation SAS are also available via an account SAS.

![An image](../../Assets/Pasted image 20240819105537.png)
### How shared access signatures work

When you use a SAS to access data stored in Azure Storage, you need two components. The first is a URI to the resource you want to access. The second part is a SAS token that you've created to authorize access to that resource.

In a single URI, such as `https://medicalrecords.blob.core.windows.net/patient-images/patient-116139-nq8z7f.jpg?sp=r&st=2020-01-20T11:42:32Z&se=2020-01-20T19:42:32Z&spr=https&sv=2019-02-02&sr=b&sig=SrW1HZ5Nb6MbRzTbXCaPm%2BJiSEn15tC91Y4umMPwVZs%3D`, you can separate the URI from the SAS token as follows:

- **URI:** `https://medicalrecords.blob.core.windows.net/patient-images/patient-116139-nq8z7f.jpg?`
- **SAS token:** `sp=r&st=2020-01-20T11:42:32Z&se=2020-01-20T19:42:32Z&spr=https&sv=2019-02-02&sr=b&sig=SrW1HZ5Nb6MbRzTbXCaPm%2BJiSEn15tC91Y4umMPwVZs%3D`

The SAS token itself is made up of several components.

| Component                                              | Description                                                                                                                                                                                                                  |
| ------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `sp=r`                                                 | Controls the access rights. The values can be `a` for add, `c` for create, `d` for delete, `l` for list, `r` for read, or `w` for write. This example is read only. The example `sp=acdlrw` grants all the available rights. |
| `st=2020-01-20T11:42:32Z`                              | The date and time when access starts.                                                                                                                                                                                        |
| `se=2020-01-20T19:42:32Z`                              | The date and time when access ends. This example grants eight hours of access.                                                                                                                                               |
| `sv=2019-02-02`                                        | The version of the storage API to use.                                                                                                                                                                                       |
| `sr=b`                                                 | The kind of storage being accessed. In this example, b is for blob.                                                                                                                                                          |
| `sig=SrW1HZ5Nb6MbRzTbXCaPm%2BJiSEn15tC91Y4umMPwVZs%3D` | The cryptographic signature.                                                                                                                                                                                                 |
### Best practices

To reduce the potential risks of using a SAS, Microsoft provides some guidance:

- To securely distribute a SAS and prevent man-in-the-middle attacks, always use HTTPS.
- The most secure SAS is a user delegation SAS. Use it wherever possible because it removes the need to store your storage account key in code. You must use Microsoft Entra ID to manage credentials. This option might not be possible for your solution.
- Try to set your expiration time to the smallest useful value. If a SAS key becomes compromised, it can be exploited for only a short time.
- Apply the rule of minimum-required privileges. Only grant the access that's required. For example, in your app, read-only access is sufficient.
- There are some situations where a SAS isn't the correct solution. When there's an unacceptable risk of using a SAS, create a middle-tier service to manage users and their access to storage.

### Choose when to use shared access signatures

Use a SAS when you want to provide secure access to resources in your storage account to any client who doesn't otherwise have permissions to those resources.

A common scenario where a SAS is useful is a service where users read and write their own data to your storage account. In a scenario where a storage account stores user data, there are two typical design patterns:

- Clients upload and download data via a front-end proxy service, which performs authentication. This front-end proxy service has the advantage of allowing validation of business rules, but for large amounts of data or high-volume transactions, creating a service that can scale to match demand may be expensive or difficult.

![An image](../../Assets/Pasted image 20240819110244.png)

- A lightweight service authenticates the client as needed and then generates a SAS. Once the client application receives the SAS, they can access storage account resources directly with the permissions defined by the SAS and for the interval allowed by the SAS. The SAS mitigates the need for routing all data through the front-end proxy service.

![An image](../../Assets/Pasted image 20240819110337.png)
Many real-world services might use a hybrid of these two approaches. For example, some data might be processed and validated via the front-end proxy, while other data is saved and/or read directly using SAS.

Additionally, a SAS is required to authorize access to the source object in a copy operation in certain scenarios:

- When you copy a blob to another blob that resides in a different storage account, you must use a SAS to authorize access to the source blob. You can optionally use a SAS to authorize access to the destination blob as well.
- When you copy a file to another file that resides in a different storage account, you must use a SAS to authorize access to the source file. You can optionally use a SAS to authorize access to the destination file as well.
- When you copy a blob to a file, or a file to a blob, you must use a SAS to authorize access to the source object, even if the source and destination objects reside within the same storage account.

### Explore stored access policies

A stored access policy provides an extra level of control over service-level shared access signatures (SAS) on the server side. Establishing a stored access policy groups SAS and provides more restrictions for signatures that bound by the policy. You can use a stored access policy to change the start time, expiry time, or permissions for a signature, or to revoke it after it is issued.

The following storage resources support stored access policies:

- Blob containers
- File shares
- Queues
- Tables

#### Creating a stored access policy

![An image](../../Assets/Pasted image 20240819110800.png)
#### Modifying or revoking a stored access policy

To modify the parameters of the stored access policy you can call the access control list operation for the resource type to replace the existing policy. For example, if your existing policy grants read and write permissions to a resource, you can modify it to grant only read permissions for all future requests.

To revoke a stored access policy you can delete it, rename it by changing the signed identifier, or change the expiry time to a value in the past. Changing the signed identifier breaks the associations between any existing signatures and the stored access policy. Changing the expiry time to a value in the past causes any associated signatures to expire. Deleting or modifying the stored access policy immediately affects all of the SAS associated with it.

To remove a single access policy, call the resource's `Set ACL` operation, passing in the set of signed identifiers that you wish to maintain on the container. To remove all access policies from the resource, call the `Set ACL` operation with an empty request body.

## Explore Microsoft Graph

After completing this module, you'll be able to:

- Explain the benefits of using Microsoft Graph
- Perform operations on Microsoft Graph by using REST and SDKs
- Apply best practices to help your applications get the most out of Microsoft Graph

### Discover Microsoft Graph

Microsoft Graph is the gateway to data and intelligence in Microsoft 365. It provides a unified programmability model that you can use to access the tremendous amount of data in Microsoft 365, Windows 10, and Enterprise Mobility + Security.

![An image](../../Assets/Pasted image 20240819112657.png)

In the Microsoft 365 platform, three main components facilitate the access and flow of data:

- The Microsoft Graph API offers a single endpoint, `https://graph.microsoft.com`. You can use REST APIs or SDKs to access the endpoint. Microsoft Graph also includes a powerful set of services that manage user and device identity, access, compliance, security, and help protect organizations from data leakage or loss.
- [Microsoft Graph connectors](https://learn.microsoft.com/en-us/microsoftsearch/connectors-overview) work in the incoming direction, **delivering data external to the Microsoft cloud into Microsoft Graph services and applications**, to enhance Microsoft 365 experiences such as Microsoft Search. Connectors exist for many commonly used data sources such as Box, Google Drive, Jira, and Salesforce.
- [Microsoft Graph Data Connect](https://learn.microsoft.com/en-us/graph/overview#access-microsoft-graph-data-at-scale-using-microsoft-graph-data-connect) provides a set of tools to streamline secure and scalable **delivery of Microsoft Graph data to popular Azure data stores**. The cached data serves as data sources for Azure development tools that you can use to build intelligent applications.

### Query Microsoft Graph by using REST

Microsoft Graph is a RESTful web API that enables you to access Microsoft Cloud service resources. After you register your app and get authentication tokens for a user or service, you can make requests to the Microsoft Graph API.

The Microsoft Graph API defines most of its resources, methods, and enumerations in the OData namespace, `microsoft.graph`, in the [Microsoft Graph metadata](https://learn.microsoft.com/en-us/graph/traverse-the-graph#microsoft-graph-api-metadata). A few API sets are defined in their sub-namespaces, such as the [call records API](https://learn.microsoft.com/en-us/graph/api/resources/callrecords-api-overview) which defines resources like [callRecord](https://learn.microsoft.com/en-us/graph/api/resources/callrecords-callrecord) in `microsoft.graph.callRecords`.

Unless explicitly specified in the corresponding topic, assume types, methods, and enumerations are part of the `microsoft.graph` namespace.

#### Call a REST API method

To read from or write to a resource such as a user or an email message, construct a request that looks like the following:

```
{HTTP method} https://graph.microsoft.com/{version}/{resource}?{query-parameters}
```

The components of a request include:

- `{HTTP method}` - The HTTP method used on the request to Microsoft Graph.
- `{version}` - The version of the Microsoft Graph API your application is using.
- `{resource}` - The resource in Microsoft Graph that you're referencing.
- `{query-parameters}` - Optional OData query options or REST method parameters that customize the response.

After you make a request, a response is returned that includes:

- Status code - An HTTP status code that indicates success or failure.
- Response message - The data that you requested or the result of the operation. The response message can be empty for some operations.
- `nextLink` - If your request returns numerous data, you need to page through it by using the URL returned in `@odata.nextLink`.

#### Version

Microsoft Graph currently supports two versions: `v1.0` and `beta`.

- `v1.0` includes generally available APIs. Use the v1.0 version for all production apps.
- `beta` includes APIs that are currently in preview. Because we might introduce breaking changes to our beta APIs, we recommend that you use the beta version only to test apps that are in development; don't use beta APIs in your production apps.

#### Resource

A resource can be an entity or complex type, commonly defined with properties. Entities differ from complex types by always including an **id** property.

Your URL includes the resource you're interacting with in the request, such as `me`, **user**, **group**, **drive**, and **site**. Often, top-level resources also include _relationships_, which you can use to access other resources, like `me/messages` or `me/drive`. You can also interact with resources using _methods_; for example, to send an email, use `me/sendMail`.

Each resource might require different permissions to access it. You often need a higher level of permissions to create or update a resource than to read it. For details about required permissions, see the method reference topic.

#### Query parameters

Query parameters can be OData system query options, or other strings that a method accepts to customize its response.

You can use optional OData system query options to include more or fewer properties than the default response, filter the response for items that match a custom query, or provide another parameters for a method.

For example, adding the following `filter` parameter restricts the messages returned to only those with the `emailAddress` property of `jon@contoso.com`.

```HTTP
GET https://graph.microsoft.com/v1.0/me/messages?filter=emailAddress eq 'jon@contoso.com'
```

### Query Microsoft Graph by using SDKs

####  Create a Microsoft Graph client

```C#
var scopes = new[] { "User.Read" };

// Multi-tenant apps can use "common",
// single-tenant apps must use the tenant ID from the Azure portal
var tenantId = "common";

// Value from app registration
var clientId = "YOUR_CLIENT_ID";

// using Azure.Identity;
var options = new TokenCredentialOptions
{
    AuthorityHost = AzureAuthorityHosts.AzurePublicCloud
};

// Callback function that receives the user prompt
// Prompt contains the generated device code that you must
// enter during the auth process in the browser
Func<DeviceCodeInfo, CancellationToken, Task> callback = (code, cancellation) => {
    Console.WriteLine(code.Message);
    return Task.FromResult(0);
};

// /dotnet/api/azure.identity.devicecodecredential
var deviceCodeCredential = new DeviceCodeCredential(
    callback, tenantId, clientId, options);

var graphClient = new GraphServiceClient(deviceCodeCredential, scopes);
```

#### Read information from Microsoft Graph

To read information from Microsoft Graph, you first need to create a request object and then run the `GET` method on the request.

```C#
// GET https://graph.microsoft.com/v1.0/me

var user = await graphClient.Me
    .GetAsync();
```

#### Retrieve a list of entities

Retrieving a list of entities is similar to retrieving a single entity except there are other options for configuring the request. The `$filter` query parameter can be used to reduce the result set to only those rows that match the provided condition. The `$orderBy` query parameter requests that the server provides the list of entities sorted by the specified properties.

```C#
// GET https://graph.microsoft.com/v1.0/me/messages?$select=subject,sender&$filter=<some condition>&orderBy=receivedDateTime

var messages = await graphClient.Me.Messages
    .Request()
    .Select(m => new {
        m.Subject,
        m.Sender
    })
    .Filter("<filter condition>")
    .OrderBy("receivedDateTime")
    .GetAsync();
```

#### Delete an entity

Delete requests are constructed in the same way as requests to retrieve an entity, but use a `DELETE` request instead of a `GET`.

```C#
// DELETE https://graph.microsoft.com/v1.0/me/messages/{message-id}

string messageId = "AQMkAGUy...";
var message = await graphClient.Me.Messages[messageId]
    .Request()
    .DeleteAsync();
```

#### Create a new entity

For SDKs that support a fluent style, new items can be added to collections with an `Add` method. For template-based SDKs, the request object exposes a `post` method.

```C#
// POST https://graph.microsoft.com/v1.0/me/calendars

var calendar = new Calendar
{
    Name = "Volunteer"
};

var newCalendar = await graphClient.Me.Calendars
    .Request()
    .AddAsync(calendar);
```

### Apply best practices to Microsoft Graph

#### Authentication

To access the data in Microsoft Graph, your application needs to acquire an OAuth 2.0 access token, and presents it to Microsoft Graph in either of the following methods:

- The HTTP _Authorization_ request header, as a _Bearer_ token
- The graph client constructor, when using a Microsoft Graph client library

Use the Microsoft Authentication Library API, [MSAL](https://learn.microsoft.com/en-us/azure/active-directory/develop/active-directory-v2-libraries) to acquire the access token to Microsoft Graph.

#### Consent and authorization

Apply the following best practices for consent and authorization in your app:

- **Use least privilege**. Only request permissions that are necessary, and only when you need them. For the APIs, your application calls check the permissions section in the method topics. For example, see [creating a user](https://learn.microsoft.com/en-us/graph/api/user-post-users) and choose the least privileged permissions.
- **Use the correct permission type based on scenarios**. If you're building an interactive application where a signed in user is present, your application should use _delegated_ permissions. If, however, your application runs without a signed-in user, such as a background service or daemon, your application should use application permissions.
- **Consider the end user and admin experience**. Directly affects end user and admin experiences. For example:
    - Consider who will be consenting to your application, either end users or administrators, and configure your application to [request permissions appropriately](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent).
    - Ensure that you understand the difference between [static, dynamic and incremental consent](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent#consent-types).
- **Consider multi-tenant applications**. Expect customers to have various application and consent controls in different states. For example:
    - Tenant administrators can disable the ability for end users to consent to applications. In this case, an administrator would need to consent on behalf of their users.
    - Tenant administrators can set custom authorization policies such as blocking users from reading other user's profiles, or limiting self-service group creation to a limited set of users. In this case, your application should expect to handle 403 error response when acting on behalf of a user.

![An image](../../Assets/Pasted image 20240819133320.png)
#### Handle responses effectively

The following are some of the most important practices to follow to ensure that your application behaves reliably and predictably for your end users. For example:

- **Pagination**: When querying resource collections, you should expect that Microsoft Graph returns the result set in multiple pages, due to server-side page size limits. Your application should **always** handle the possibility that the responses are paged in nature, and use the `@odata.nextLink` property to obtain the next paged set of results, until all pages of the result set are read. The final page doesn't include an `@odata.nextLink` property. For more information, visit [paging](https://learn.microsoft.com/en-us/graph/paging).
- **Evolvable enumerations**: Adding members to existing enumerations can break applications already using these enums. Evolvable enums are a mechanism that Microsoft Graph API uses to add new members to existing enumerations without causing a breaking change for applications. By default, a GET operation returns only known members for properties of evolvable enum types and your application needs to handle only the known members. If you design your application to handle unknown members as well, you can opt in to receive those members by using an HTTP `Prefer` request header.

#### Storing data locally

Your application should ideally make calls to Microsoft Graph to retrieve data in real time as necessary. You should only cache or store data locally necessary for a specific scenario, and if that use case is covered by your terms of use and privacy policy, and doesn't violate the [Microsoft APIs Terms of Use](https://learn.microsoft.com/en-us/legal/microsoft-apis/terms-of-use?context=/graph/context). Your application should also implement proper retention and deletion policies.