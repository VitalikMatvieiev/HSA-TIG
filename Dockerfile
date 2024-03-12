FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["*/TestDocker.csproj", "TestDocker/"]
RUN dotnet restore "TestDocker/TestDocker.csproj"
COPY . .
WORKDIR "/src/TestDocker"
RUN dotnet publish "TestDocker.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final  
WORKDIR /app
COPY --from=build /app/publish .   
ENTRYPOINT ["dotnet", "TestDocker.dll"]
