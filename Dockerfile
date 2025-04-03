# Вказуємо базовий образ для збірки
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Копіюємо проектні файли та відновлюємо залежності
COPY *.csproj ./
RUN dotnet restore 

# Копіюємо весь код і компілюємо додаток
COPY . ./
RUN dotnet publish -c Release -o out

# Створюємо фінальний образ на основі .NET Runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

# Копіюємо зібрану програму з попереднього етапу
COPY --from=build-env /app/out .

# Встановлюємо точку входу для запуску додатка
ENTRYPOINT ["dotnet", "dotnetwebapp.dll"]
