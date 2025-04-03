# 1. Вказуємо базовий образ для збірки
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# 2. Копіюємо тільки .csproj файли для кешування залежностей
COPY ["dotnetwebapp.csproj", "./"]
RUN dotnet restore

# 3. Копіюємо весь код і компілюємо додаток
COPY . ./
RUN dotnet publish -c Release -o out

# 4. Створюємо фінальний образ на основі .NET Runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

# 5. Копіюємо зібрану програму з попереднього етапу
COPY --from=build-env /app/out .

# 6. Встановлюємо користувача для безпечного запуску
RUN adduser --disabled-password --gecos '' appuser
USER appuser

# 7. Виставляємо порт для контейнера (необов'язково)
EXPOSE 5000

# 8. Встановлюємо точку входу для запуску додатка
ENTRYPOINT ["dotnet", "dotnetwebapp.dll"]
