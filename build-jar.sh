#!/bin/bash

# Скрипт для конвертации shizik-client.tar.gz в JAR модуль

set -e

echo "🔧 Начинаем обработку Shizik Client..."

# Создаем временную папку
WORK_DIR="shizik-build-temp"
mkdir -p "$WORK_DIR"

# Извлекаем архив
echo "📦 Извлекаем архив..."
tar -xzf shizik-client.tar.gz -C "$WORK_DIR"

# Переходим в папку с содержимым
cd "$WORK_DIR"

# Проверяем, есть ли build.gradle или pom.xml
if [ -f "build.gradle" ]; then
    echo "🏗️  Найден build.gradle, используем Gradle..."
    if command -v gradle &> /dev/null; then
        gradle clean build
        cp build/libs/*.jar ../shizik-client.jar
    else
        echo "⚠️  Gradle не установлен. Используем gradlew..."
        chmod +x gradlew
        ./gradlew clean build
        cp build/libs/*.jar ../shizik-client.jar
    fi
elif [ -f "pom.xml" ]; then
    echo "🏗️  Найден pom.xml, используем Maven..."
    mvn clean package
    cp target/*.jar ../shizik-client.jar
else
    echo "📂 Нет build.gradle или pom.xml, упаковываем как есть..."
    jar cf ../shizik-client.jar .
fi

# Очищаем временную папку
cd ..
rm -rf "$WORK_DIR"

echo "✅ Готово! Файл создан: shizik-client.jar"
ls -lh shizik-client.jar
