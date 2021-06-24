FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS base
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["Testpipeline.csproj", "./"]
RUN dotnet restore "Testpipeline.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Testpipeline.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Testpipeline.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Testpipeline.dll"]
