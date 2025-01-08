# Getting Started

Open a command shell, and enter the following command:

```bash
dotnet new webapp --output aspnetcoreapp --no-https
```

The preceding command creates a new web app project in a directory named `aspnetcoreapp`. The project doesn't use HTTPS.

## Run the app

Run the following commands:

```bash
cd aspnetcoreapp
dotnet run
```

## Edit a Razor page

Change the home page:

```cshtml
@page
@model IndexModel
@{
    ViewData["Title"] = "Home page";
}

<div class="text-center">
    <h1 class="display-4">Welcome</h1>
    <p>Hello, world! The time on the server is @DateTime.Now</p>
</div>
```
