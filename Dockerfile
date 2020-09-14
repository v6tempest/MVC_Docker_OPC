FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS=http://*:5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["MVC_Docker_OPC.csproj", "./"]
RUN dotnet restore "./MVC_Docker_OPC.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "MVC_Docker_OPC.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MVC_Docker_OPC.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MVC_Docker_OPC.dll"]
